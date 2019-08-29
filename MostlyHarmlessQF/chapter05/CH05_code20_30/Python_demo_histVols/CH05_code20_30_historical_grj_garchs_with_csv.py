# -*- coding: utf-8 -*-
"""
Created on Wed Sep  6 09:18:34 2017

@author: yuyin
"""

import numpy as np
import pandas as pd
#import scipy.stats as ss
import matplotlib.pyplot as plt
from scipy.optimize import fmin_slsqp
#%matplotlib inline

def CtCHV(data, N, scal, out = None):
###---------------
# input: data : format either numpy or pandas
#        N : historial window
#        out: assume using log diff returns
# output std_CtC
###-----------
    if out is None:
        dfrets =scal*np.log(data.dropna()/data.dropna().shift(1)).dropna()
        print('running log diff returns')
    else:
        dfrets =scal*data.pct_change().dropna()
        print('running pct_change returns')

    T = np.size(dfrets,0)
    print(T)
    std_CtC=np.zeros((T-N,1))
    for t in range(0,T-N):
        std_CtC[t]=dfrets[t:t+N].std()

    return std_CtC

def CtCHVRNA(data, N, r, d, scal, out = None):
###---------------
# input: data : format either numpy or pandas
#        N : historial window
#        out: assume using log diff returns
# output std_CtCRNA
###-----------
    if out is None:
        dfrets =scal*np.log(data.dropna()/data.dropna().shift(1)).dropna()
        print('running log diff returns')
    else:
        dfrets =scal*data.pct_change().dropna()
        print('running pct_change returns')

    T = np.size(dfrets,0)
    print(T)
    std_CtCRNA=np.zeros((T-N,1))
    for t in range(0,T-N):
        std_CtCRNA[t]=dfrets[t:t+N].std()-r+d

    return std_CtCRNA

def GermanKlassHV(HDD, LDD, ODD, CDD, N, scal):
    un = scal*np.log(HDD/ODD)
    dn = scal*np.log(LDD/ODD)
    cn = scal*np.log(CDD/ODD)
    C1=0.511
    C2=0.019
    C3=0.385

    T = np.size(HDD,0)
    std_gk=np.zeros((T-N,1))
    for i in range(0,T-N):
        prt1 = (C1/N)*(np.sum((un[i:i+N]-dn[i:i+N])**2))
        pprt1 = cn[i:i+N]*(un[i:i+N]+dn[i:i+N])
        pprt2 = 2*un[i:i+N]*dn[i:i+N]
        prt2 = -(C2/N)*np.sum(pprt1+pprt2)
        prt3 = -(C3/N)*np.sum(cn[i:i+N]**2)
        std_gk[i]=np.sqrt(prt1+prt2+prt3)

    return std_gk

def parkinsonHV(HDD, LDD, ODD, N, scal):
    un = scal*np.log(HDD/ODD)
    dn = scal*np.log(LDD/ODD)

    T = np.size(HDD,0)
    std_park=np.zeros((T-N,1))
    for i in range(0,T-N):
        std_park[i]=np.sqrt((1/(4*N*np.log(2)))*np.sum((un[i:i+N]-dn[i:i+N])**2))

    return std_park

def RogersSatchellHV(HDD, LDD, ODD, CDD, N, scal):
    un = scal*np.log(HDD/ODD)
    dn = scal*np.log(LDD/ODD)
    cn = scal*np.log(CDD/ODD)

    T = np.size(HDD,0)
    std_rs=np.zeros((T-N,1))
    for i in range(0,T-N):
        tmp=un[i:i+N]*(un[i:i+N]-cn[i:i+N])+dn[i:i+N]*(dn[i:i+N]-cn[i:i+N]);
        std_rs[i]=np.sqrt(np.mean(tmp));

    return std_rs

def gjr_garch_likelihood(parameters, data, sigma2, out = None):
    mu = parameters[0]
    omega = parameters[1]
    alpha = parameters[2]
    gamma = parameters[3]
    beta = parameters[4]

    T = np.size(data,0)
    eps = data - mu
    for t in range(1,T):
        sigma2[t]=(omega+alpha*eps[t-1]**2+gamma*eps[t-1]**2 * (eps[t-1]<0)+beta*sigma2[t-1])

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


df = pd.read_excel(".\yyfQFdata\SH600000.xlsx",parse_dates=[0])
df[:5]
df.index=df.pop('Date')

df.plot(grid=True,figsize=(10,6))
df.head()

N=252
scal=100
r=0.03 #risk-free rate
d=0.01 #dividen rate

HDD=np.array(df.HDD)
LDD=np.array(df.LDD)
ODD=np.array(df.ODD)
CDD=np.array(df.CDD)


std_CtC = CtCHV(df.CDD,N,scal)
std_CtCRNA =  CtCHVRNA(df.CDD, N, r, d, scal)
std_park = parkinsonHV(HDD, LDD, ODD, N, scal)
std_gk = GermanKlassHV(HDD, LDD, ODD, CDD, N, scal)
std_rs = RogersSatchellHV(HDD, LDD, ODD, CDD, N, scal)

df.CDD
dfrets = scal*np.log(df.CDD.dropna()/df.CDD.dropna().shift(1)).dropna()
dfrets

mean_rts = dfrets.mean()
var_rts =dfrets.var();

#demo volatilities with given parameters
startingVals = np.array([mean_rts,
                       var_rts*.01,
                       .03,.09,.90])
T=len(dfrets)
finfo=np.finfo(np.float64)
bounds  =[(-10*mean_rts,10*mean_rts),
         (finfo.eps,2*var_rts),
         (0.0,1.0),(0.0,1.0),(0.0,1.0)]

sigma2 = np.ones(T)*(var_rts)

args = (np.asarray(dfrets),sigma2)

estimates = fmin_slsqp(gjr_garch_likelihood, startingVals, f_ieqcons=gjr_constraint, bounds=bounds, args =args)

print('Initial Values=',startingVals)
print('Estimated Values=',estimates)

analized=1 # or we should set to 252
sigma2 = np.ones(T)*(var_rts)
loglik, _, sigma2final = gjr_garch_likelihood(estimates,np.array(dfrets), sigma2, out=True)

gjr_vol=np.sqrt(analized*sigma2final)

ested_vol = pd.DataFrame(gjr_vol,index=dfrets.index,columns=['Estimated GJR_Garch Vols'])

CtC_HV = pd.DataFrame(std_CtC,index=dfrets.index[N:],columns=['CtC HV'])
CtCRNA_HV = pd.DataFrame(std_CtCRNA,index=dfrets.index[N:],columns=['CtCRNA HV'])
rs_HV = pd.DataFrame(std_rs,index=dfrets.index[N-1:],columns=['RogersSatchell HV'])
park_HV = pd.DataFrame(std_park,index=dfrets.index[N-1:],columns=['parkinson HV'])
gk_HV = pd.DataFrame(std_gk,index=dfrets.index[N-1:],columns=['GermanKlass HV'])

df_Vols=pd.concat([ested_vol,CtC_HV,CtCRNA_HV,rs_HV,park_HV,gk_HV],axis=1)
df_Vols.plot(figsize=(12,10),grid=True)

df_Vols.loc[:,'CDD Log Returns']=dfrets
df_Vols[N-2:N-7]

tmpx1= df_Vols['CDD Log Returns']/df_Vols['Estimated GJR_Garch Vols']
tmpx2= df_Vols['CDD Log Returns']/df_Vols['CtC HV']
tmpx3= df_Vols['CDD Log Returns']/df_Vols['CtCRNA HV']
tmpx4= df_Vols['CDD Log Returns']/df_Vols['RogersSatchell HV']
tmpx5= df_Vols['CDD Log Returns']/df_Vols['parkinson HV']
tmpx6= df_Vols['CDD Log Returns']/df_Vols['GermanKlass HV']
#df_Vols['Estimated GJR_Garch Vols']

df_Vols.loc[:,'NRets_GJR']=tmpx1
df_Vols.loc[:,'NRets_CtC']=tmpx2
df_Vols.loc[:,'NRets_GtCRNA']=tmpx3
df_Vols.loc[:,'NRets_RogersSatchell']=tmpx4
df_Vols.loc[:,'NRets_parkinson']=tmpx5
df_Vols.loc[:,'NRets_GermanKlass']=tmpx6

print('ested loglik=',loglik)

llist= df_Vols.columns.tolist()

print('Type     ||','mean||','std||','skew||','kurt||')
for ii in range(len(llist)):
    #print (ii,llist[ii])
    #aa=df_Vols[llist[ii]].describe()
    #aa['skew']=df_Vols[llist[ii]].skew()
    #aa['kurtosis']=df_Vols[llist[ii]].skew()
    a1=df_Vols[llist[ii]].mean()
    a2=df_Vols[llist[ii]].std()
    a3=df_Vols[llist[ii]].skew()
    a4=df_Vols[llist[ii]].kurtosis()
    print(llist[ii],'%10.4f'%(a1),'%10.4f'%(a2),'%10.4f'%(a3),'%10.4f'%(a4))


df_Vols.to_csv("yyfQFdataout/SH60000_HV_gjr_vols.csv",index_label='date')
df_Vols.to_excel("yyfQFdataout/SH60000_HV_gjr_vols.xls",index_label='date')

plt.show()
