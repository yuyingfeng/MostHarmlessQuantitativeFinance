# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 19:35:06 2019

@author: yuyin
"""

import numpy as np
import pandas as pd
import scipy.stats as ss
import matplotlib.pyplot as plt
#%matplotlib inline



def riskmetrics_volatilities(parameters, data, sigma2):
        alpha = parameters[0]
        beta = parameters[1]
        T=len(data)

        for t in range(1,T):
            sigma2[t]=(alpha*data[t-1]**2+beta*sigma2[t-1]) #yyf v2
        
        return np.copy(sigma2)

def garch_volatilities_v1(parameters, data, sigma2):
        alpha = parameters[0]
        beta = parameters[1]
        T=len(data)

        # Data and Sigma2 are assumed as T by 1 vectors
        omega=sigma2[0]*(1-alpha-beta)
        for t in range(1,T):
            sigma2[t]=omega+(alpha*data[t-1]**2+beta*sigma2[t-1]) #yyf v2
        
        return np.copy(sigma2)

def garch_volatilities_v2(parameters, data, sigma2):
        mu = parameters[0]
        alpha = parameters[1]
        beta = parameters[2]
        
        #T = np.size(data,0)
        T=len(data)
        eps = data - mu #kevein v1

        # Data and Sigma2 are assumed as T by 1 vectors
        for t in range(1,T):
            sigma2[t]=(alpha*eps[t-1]**2+beta*sigma2[t-1]) #kevein v1
            
        return np.copy(sigma2)

def Ngarch_volatilities(parameters, data, sigma2):
        alpha = parameters[0]
        beta = parameters[1]
        theta =parameters[2]
        
        T=len(data)
        omega=sigma2[0]*(1-alpha*(1+theta**2)-beta)
        for t in range(1,T):
            eps= data[t-1]-theta*np.sqrt(sigma2[t-1])
            sigma2[t]=omega+(alpha*eps**2+beta*sigma2[t-1])
        
        return np.copy(sigma2)

def General_Ngarch_volatilities(parameters, data, sigma2):
        alpha = parameters[0]
        beta = parameters[1]
        theta1 =parameters[2]
        theta2 =parameters[3]
        theta3 =parameters[4]
        
        T=len(data)
        
        omega=sigma2[0]*(1-alpha*(theta1-theta2*(1-theta1)**(2*theta3))-beta)
        for t in range(1,T):
            z=data[t-1]/np.sqrt(sigma2[t-1])
            NIF= np.power(np.abs(z-theta1)-theta2*(z-theta1),2*theta3)
            sigma2[t]=omega+(alpha*NIF*sigma2[t-1]+beta*sigma2[t-1])
    
        return np.copy(sigma2)

def gjr_garch_volatilities(parameters, data, sigma2):
        mu = parameters[0]
        omega = parameters[1]
        alpha = parameters[2]
        gamma = parameters[3]
        beta = parameters[4]
        
        T = len(data)
        #print('What is T=',T)
        eps = data - mu
        # Data and Sigma2 are T by 1 vectors
        for t in range(1,T):
            sigma2[t]=(omega+alpha*eps[t-1]**2+gamma*eps[t-1]**2 * (eps[t-1]<0)+beta*sigma2[t-1])
            
        
        return np.copy(sigma2)

def VaR_norm(vols, p):
    T=len(vols)
    invpdf=ss.norm.ppf(p)
    VaR =-invpdf*vols
    return VaR
    
    
def mynormqqplot(data):
    std_data=data.std()
    s_rts = np.sort(data,axis=0)
    len_s_rts=len(s_rts)
    norm_quant_rts=np.zeros([len_s_rts,1])
    for i in range(0,len_s_rts):
        norm_quant_rts[i]=ss.norm.ppf((i+1.0-0.5)/len_s_rts)
    
    plt.figure()
    plt.scatter(norm_quant_rts,s_rts)
    
    min_qt=np.min(norm_quant_rts)
    min_s=np.min(s_rts)
    min_ax =np.max([min_qt,min_s])
    
    max_qt=np.max(norm_quant_rts)
    max_s=np.max(s_rts)
    max_ax =np.min([max_qt,max_s])
    
    ax_x=np.linspace(min_ax,max_ax,len_s_rts)
    ax_y=std_data*ax_x #std_data is like a slope
    plt.plot(ax_x,ax_y,'-',color='r')
    plt.grid(True)
    plt.xlabel('theoretical quantiles')
    plt.ylabel('sample quantiles')
# mynormqqplot function END

df = pd.read_excel("yyf_prices.xls",parse_dates=[0])
df.index=df.pop('Date')
#df.hist(figsize=[10,10])

df_log_rets = 100* np.log(df.dropna()/df.dropna().shift(1)).dropna()

tmpdata= df_log_rets.SZINDEX

# other possible data test
#tmpdata= df_log_rets.EURUSD
#tmpdata= df_log_rets.SP500
#tmpdata= df_log_rets.SHINDEX
#tmpdata= df_log_rets.SZINDEX

mean_rts = tmpdata.mean()
var_rts  = tmpdata.var()
std_rts = tmpdata.std()

T=tmpdata.count()

sigma2 = np.ones(T)*(var_rts) #initialized volatilities
analized=1 # or we should set to 252
startingVals = np.array([mean_rts,.06,.94]) ##change

#sigma2final = riskmetrics_volatilities(startingVals[1:],np.array(tmpdata), sigma2)
#sigma2final = garch_volatilities_v1(startingVals[1:],np.array(tmpdata), sigma2)
#sigma2final = garch_volatilities_v2(startingVals,np.array(tmpdata), sigma2)

# start Ngarch
#initial_vals = np.array([0.07,0.85,0.50])
#sigma2final = Ngarch_volatilities(initial_vals,np.array(tmpdata), sigma2)
# end Ngarch

# start general Ngarch
initial_vals = np.array([0.07,0.85,0.02,0.5,0.75])
sigma2final = General_Ngarch_volatilities(initial_vals,np.array(tmpdata), sigma2)
# end Ngarch

#initial_vals = np.array([mean_rts,var_rts*.01,0.03,0.09,0.90])
#sigma2final = gjr_garch_volatilities(initial_vals,np.array(tmpdata), sigma2)

garch_vol=np.sqrt(analized*sigma2final)

gr_vol = pd.DataFrame(garch_vol,index=tmpdata.index,columns=['Garch Volatilities'])

gr_vol.plot(figsize=(12,7),grid=True)


normalized_new_rts=np.asarray(tmpdata)/garch_vol

gr_vol.loc[:,'Standerized Returns'] = normalized_new_rts
gr_vol.loc[:,'Log Returns'] = tmpdata

VaR = np.zeros(T) #initialized VaR
p=0.01
VaR = VaR_norm(garch_vol,p)
gr_vol.loc[:,'VaR'] = VaR

# call our function ‘mynormqqplot’
#gr_vol

ttmp=normalized_new_rts/(normalized_new_rts.std())
# plot standerized returns using Garch 11
plt.figure()
mynormqqplot(normalized_new_rts)

#calculate FOUR MOMENTS of standerized returns using Garch 11
a1=ttmp.mean()
a2=ttmp.std()
a3=ss.skew(ttmp)
a4 =ss.kurtosis(ttmp)

std_rts=tmpdata.std()
normalized_log_rts=np.asarray(tmpdata)/std_rts

#calculate FOUR MOMENTS of original log returns
b1=normalized_log_rts.mean()
b2=normalized_log_rts.std()
b3=ss.skew(normalized_log_rts)
b4 =ss.kurtosis(normalized_log_rts)

print('Type     ||','mean||','std||','skew||','kurt||')
print('Original data:  ',b1,b2,b3,b4)
print('After Garch:  ',a1,a2,a3,a4)

gr_vol.to_csv("garch_vols.csv",index_label='date')
gr_vol.to_excel("garch_vols.xls",index_label='date')
