# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 19:43:36 2019

@author: yuyin
"""

import numpy as np
import pandas as pd
import scipy.stats as ss
import statsmodels.api as sm
import matplotlib.pyplot as plt
from scipy.optimize import fmin_slsqp
#%matplotlib inline

def riskmetrics_likelihood(parameters, data, sigma2,out = None):
        alpha = parameters[0]
        beta = parameters[1]
        T=len(data)

        # Data and Sigma2 are assumed as T by 1 vectors

        #sigma2[0]=(np.std(data))**2 #yyf v2
        for t in range(1,T):
            sigma2[t]=(alpha*data[t-1]**2+beta*sigma2[t-1]) #yyf v2
        
        logliks = 0.5*(np.log(2*np.pi)+np.log(sigma2)+data**2/sigma2)
        loglik = np.sum(logliks)
        
        if out is None:
            return loglik
        else:
            return loglik, logliks, np.copy(sigma2)
        
def riskmetrics_constraint(parameters, data, sigma2, out=None):
        alpha = parameters[0]
        beta = parameters[1]
        return np.array([1-alpha-beta])

def garch_likelihood_v1(parameters, data, sigma2,out = None):
        alpha = parameters[0]
        beta = parameters[1]
        T=len(data)

        # Data and Sigma2 are assumed as T by 1 vectors
        
        #sigma2[0]=(np.std(data))**2 #yyf v2
        omega=sigma2[0]*(1-alpha-beta)
        for t in range(1,T):
            sigma2[t]=omega+(alpha*data[t-1]**2+beta*sigma2[t-1]) #yyf v2
        
        logliks = 0.5*(np.log(2*np.pi)+np.log(sigma2)+data**2/sigma2)
        loglik = np.sum(logliks)
        
        if out is None:
            return loglik
        else:
            return loglik, logliks, np.copy(sigma2)

def garch_constraint_v1(parameters, data, sigma2, out=None):
        alpha = parameters[0]
        beta = parameters[1]
        return np.array([1-alpha-beta])

def garch_likelihood_v2(parameters, data, sigma2,out = None):
        mu = parameters[0]
        alpha = parameters[1]
        beta = parameters[2]
        
        T=len(data)
        eps = data-mu 
        for t in range(1,T):
            sigma2[t]=(alpha*eps[t-1]**2+beta*sigma2[t-1]) 
            
        logliks = 0.5*(np.log(2*np.pi)+np.log(sigma2)+eps**2/sigma2)
        loglik = np.sum(logliks)
        
        if out is None:
            return loglik
        else:
            return loglik, logliks, np.copy(sigma2)

def garch_constraint_v2(parameters, data, sigma2, out=None):
        alpha = parameters[1]
        beta = parameters[2]
        return np.array([1-alpha-beta])


def Ngarch_likelihood(parameters, data, sigma2,out = None):
        omega = parameters[0]
        alpha = parameters[1]
        beta = parameters[2]
        theta =parameters[3]        
        T=len(data)

        for t in range(1,T):
            eps= data[t-1]-theta*np.sqrt(sigma2[t-1])
            sigma2[t]=omega+(alpha*eps**2+beta*sigma2[t-1]) #yyf v2
        
        logliks = 0.5*(np.log(2*np.pi)+np.log(sigma2)+data**2/sigma2)
        loglik = np.sum(logliks)
        
        if out is None:
            return loglik
        else:
            return loglik, logliks, np.copy(sigma2)

def Ngarch_constraint(parameters, data, sigma2, out=None):
        alpha = parameters[1]
        beta = parameters[2]
        theta = parameters[3]
        return np.array([1-alpha*(1+theta**2)-beta])

def gjr_garch_likelihood(parameters, data, sigma2, out = None):
        mu = parameters[0]
        omega = parameters[1]
        alpha = parameters[2]
        gamma = parameters[3]
        beta = parameters[4]
        
        T = len(data)

        eps = data-mu
        for t in range(1,T):
            sigma2[t]=(omega+alpha*eps[t-1]**2+gamma*(eps[t-1]**2)*(eps[t-1]<0)+beta*sigma2[t-1])
            
        logliks = 0.5*(np.log(2*np.pi)+np.log(sigma2)+eps**2/sigma2)
        loglik = np.sum(logliks)
        
        if out is None:
            return loglik
        else:
            return loglik, logliks, np.copy(sigma2)

def gjr_constraint(parameters, data, sigma2, out=None):
        alpha = parameters[2]
        gamma = parameters[3]
        beta = parameters[4]
        return np.array([1-alpha-gamma/2-beta])


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

df = pd.read_excel("yyfQFdata/yyf_prices.xls",parse_dates=[0])
df.index=df.pop('Date')
#df.hist(figsize=[10,10])

df_pct_rets = 100* df.pct_change().dropna()
df_log_rets =  100* np.log(df.dropna()/df.dropna().shift(1)).dropna()


data_names =['EURUSD','SP500','SHINDEX','SZINDEX']
data_type =data_names[3]

#nn= 0 indicates log  returns//1 indicates precentage returbs
rts_types = ['log_rts','pct_rts']
nn=0

if rts_types[nn] == 'log_rts':
    if data_type == 'EURUSD':
        tmpdata= df_log_rets.EURUSD
    elif data_type == 'SP500':
        tmpdata= df_log_rets.SP500
    elif data_type == 'SHINDEX':
        tmpdata= df_log_rets.SHINDEX
    elif data_type == 'SZINDEX':
        tmpdata= df_log_rets.SZINDEX
    else:
        print('Sorry we dont have the data samples you request.')
elif rts_types[nn] == 'pct_rts':
    if data_type == 'EURUSD':
        tmpdata= df_pct_rets.EURUSD    
    elif data_type == 'SP500':
        tmpdata= df_pct_rets.SP500
    elif data_type == 'SHINDEX':
        tmpdata= df_pct_rets.SHINDEX
    elif data_type == 'SZINDEX':
        tmpdata= df_pct_rets.SZINDEX
    else:
        print('Sorry we dont have the data samples you request.')


mean_rts = tmpdata.mean()
var_rts  = tmpdata.var()
std_rts = tmpdata.std()

T=tmpdata.count()

sigma2 = np.ones(T)*(var_rts) #initialized volatilities
args = (np.asarray(tmpdata),sigma2)
analized=1 # or we should set to 252

garch_list =['riskmetrics','garch_v1','garch_v2','Ngarch','gjr']
garch_type =garch_list[3]

if garch_type == 'riskmetrics':
# riskmetrics
    rm_initial_vals = np.array([0.4,0.96]) ##change
    iniloglik,_,_ = riskmetrics_likelihood(rm_initial_vals,np.array(tmpdata), sigma2, out=True)
    rm_bounds  =[(0.0,1.0),(0.0,1.0)]
    estimates = fmin_slsqp(riskmetrics_likelihood, rm_initial_vals, f_ieqcons=riskmetrics_constraint, bounds=rm_bounds, args =args)
    loglik, logliks, sigma2final = riskmetrics_likelihood(estimates,np.array(tmpdata), sigma2, out=True)
    print('Initial Values=',rm_initial_vals,'  Initila Likilihood=',iniloglik)
elif garch_type == 'garch_v1':
# garch v1    
    garchv1_initial_vals = np.array([.09,.90]) ##change
    iniloglik,_,_ = garch_likelihood_v1(garchv1_initial_vals,np.array(tmpdata), sigma2, out=True)
    garchv1_bounds  =[(0.0,1.0),(0.0,1.0)]
    estimates = fmin_slsqp(garch_likelihood_v1, garchv1_initial_vals, f_ieqcons=riskmetrics_constraint, bounds=garchv1_bounds, args =args)
    loglik, logliks, sigma2final = garch_likelihood_v1(estimates,np.array(tmpdata), sigma2, out=True)
    print('Initial Values=',garchv1_initial_vals,'  Initila Likilihood=',iniloglik)
elif garch_type == 'garch_v2':
# garch v2
    garchv2_initial_vals = np.array([mean_rts,.09,.90]) ##change
    iniloglik,_,_ = garch_likelihood_v2(garchv2_initial_vals,np.array(tmpdata), sigma2, out=True)
    
    garchv2_bounds  =[(-10*mean_rts,10*mean_rts),(0.0,0.5),(0.0,1.0)]
    estimates = fmin_slsqp(garch_likelihood_v2, garchv2_initial_vals, f_ieqcons=riskmetrics_constraint, bounds=garchv2_bounds, args =args)
    loglik, logliks, sigma2final = garch_likelihood_v2(estimates,np.array(tmpdata), sigma2, out=True)
    print('Initial Values=',garchv2_initial_vals,'  Initila Likilihood=',iniloglik)
elif garch_type == 'Ngarch':
# Ngarch    
    Ngarch_initial_vals = np.array([0.000005,0.07,0.85,0.50])
    iniloglik,_,_ = Ngarch_likelihood(Ngarch_initial_vals,np.array(tmpdata), sigma2, out=True)
    
    Ngarch_bounds  =[(0.0,0.99),(0.0,0.99),(0.0,1.0),(0.0,1.0)]
    estimates = fmin_slsqp(Ngarch_likelihood, Ngarch_initial_vals, f_ieqcons=Ngarch_constraint, bounds=Ngarch_bounds, args =args)
    loglik, logliks, sigma2final = Ngarch_likelihood(estimates,np.array(tmpdata), sigma2, out=True)
    print('Initial Values=',Ngarch_initial_vals,'  Initila Likilihood=',iniloglik)
elif garch_type == 'gjr':
#gjr garch
    gjr_initial_vals = np.array([mean_rts,var_rts*.01,.03,.09,.90])
    iniloglik,_,_ = gjr_garch_likelihood(gjr_initial_vals,np.array(tmpdata), sigma2, out=True)
    
    finfo=np.finfo(np.float64)
    gjr_bounds  =[(-10*mean_rts,10*mean_rts),(finfo.eps,2*var_rts),(0.0,1.0),(0.0,1.0),(0.0,1.0)]
    estimates = fmin_slsqp(gjr_garch_likelihood, gjr_initial_vals, f_ieqcons=gjr_constraint, bounds=gjr_bounds, args =args)
    print('Initial Values=',gjr_initial_vals,'  Initila Likilihood=',iniloglik)
    loglik, logliks, sigma2final = gjr_garch_likelihood(estimates,np.array(tmpdata), sigma2, out=True)
else:
    print('Sorry we dont have the type you request.')

print('Estimated Values=',estimates,'Estimated Likilihood=',loglik)


garch_vol=np.sqrt(analized*sigma2final)

gr_vol = pd.DataFrame(garch_vol,index=tmpdata.index,columns=['Garch Volatilities'])

title_name=garch_type+' volatilities'
gr_vol.plot(figsize=(12,7),grid=True,title=title_name)


normalized_new_rts=np.asarray(tmpdata)/garch_vol

gr_vol.loc[:,'Standerized Returns'] = normalized_new_rts
gr_vol.loc[:,'Log Returns'] = tmpdata
# call our function ‘mynormqqplot’
#gr_vol

ttmp=normalized_new_rts/(normalized_new_rts.std())
# plot standerized returns using Garch 11
#mynormqqplot(ttmp)
mynormqqplot(normalized_new_rts)

plt.figure()
sm.qqplot(normalized_new_rts,line='s')
plt.grid(True)
plt.xlabel('theoretical quantiles')
plt.ylabel('sample quantiles')
plt.title('Statsmodels qqplot result')


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

print('Type          ||','     mean      ||','     std     ||','      skew     ||','     kurt      ||')
print('Original data:  ',b1,b2,b3,b4)
print('After Garch:   ',a1,a2,a3,a4)