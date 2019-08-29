import numpy as np
import pandas as pd
#import scipy.stats as ss
import matplotlib.pyplot as plt
from scipy.optimize import fmin_slsqp

#from yyfQuantFin import *
import hist_vols as hvols
import garch_models as ghvols
#%matplotlib inline

df = pd.read_excel(".\yyfQFdata\SH600000.xlsx",parse_dates=[0])
df[:5]
df.index=df.pop('Date') # We have to use 'parse_dates=[0]'，otherwise pop wouldnt work

df.CDD.plot()

N=252

HDD=np.array(df.HDD)
LDD=np.array(df.LDD)
ODD=np.array(df.ODD)
CDD=np.array(df.CDD)

#std_CtC = CtCHV(df.CDD,N)
#std_park = parkinsonHV(HDD,LDD,ODD, N)
#std_gk = GermanKlassHV(HDD,LDD,ODD,CDD, N)
#std_rs = RogersSatchellHV(HDD,LDD,ODD,CDD, N)

std_CtC = hvols.CtCHV(df.CDD,N)
std_park = hvols.parkinsonHV(HDD,LDD,ODD, N)
std_gk = hvols.GermanKlassHV(HDD,LDD,ODD,CDD, N)
std_rs = hvols.RogersSatchellHV(HDD,LDD,ODD,CDD, N)

df.CDD

dfrets = (df.CDD).pct_change().dropna()
#dfrets =np.log(df.CDD/df.CDD.shift(1)).dropna() #log diff returns #comfirm many times
dfrets

mean_rts = dfrets.mean()
var_rts =dfrets.var();
T=len(dfrets);
sigma2 = np.ones(T)*(var_rts)
args = (np.asarray(dfrets),sigma2)
analized=1 # or we should set to 252

finfo=np.finfo(np.float64)
garch_type ='gjr'
#when garch_type set to garch11--> garch 1 1
#when garch_type set to other --> GJR

if garch_type == 'garch11':
#demo volatilities with given parameters
    startingVals = np.array([mean_rts,.09,.90]) ##change
    bounds  =[(-10*mean_rts,10*mean_rts),(0.0,1.0),(0.0,1.0)]

    estimates = fmin_slsqp(ghvols.garch_likelihood, startingVals, f_ieqcons=ghvols.garch_constraint, bounds=bounds, args =args)

    print('Initial Values=',startingVals)
    print('Estimated Values=',estimates)
    sigma2 = np.ones(T)*(var_rts)
    loglik, logliks, sigma2final = ghvols.garch_likelihood(estimates,np.array(dfrets), sigma2, out=True)
    garch_vol=np.sqrt(analized*sigma2final)
    ested_vol = pd.DataFrame(garch_vol,index=dfrets.index,columns=['Garch estimated vols'])

    plt.figure(figsize=(12,7),dpi=980)
    plt.grid(True)
    plt.plot(garch_vol[N:],label='Garch 11 Garch Vol')
else:
    startingVals = np.array([mean_rts,
                       var_rts*.01,
                       .03,.09,.90])
    bounds  =[(-10*mean_rts,10*mean_rts),
         (finfo.eps,2*var_rts),
         (0.0,1.0),(0.0,1.0),(0.0,1.0)]
    estimates = fmin_slsqp(ghvols.gjr_garch_likelihood, startingVals, f_ieqcons=ghvols.gjr_constraint, bounds=bounds, args =args)
    print('Initial Values=',startingVals)
    print('Estimated Values=',estimates)
    sigma2 = np.ones(T)*(var_rts)
    loglik, logliks, sigma2final = ghvols.gjr_garch_likelihood(estimates,np.array(dfrets), sigma2, out=True)
    gjr_vol=np.sqrt(analized*sigma2final)
    ested_vol = pd.DataFrame(gjr_vol,index=dfrets.index,columns=['GJR estimated vols'])
    plt.figure(figsize=(12,7),dpi=980)
    plt.grid(True)
    plt.plot(gjr_vol[N:],label='Gjr Garch Vol')
# end if-else

plt.plot(std_CtC,label='CtC HV')
plt.plot(std_rs,label='RogersSatchell HV')
plt.plot(std_park,label='parkinson HV')
plt.plot(std_gk,label='GermanKlass HV')


plt.title('Histirical Volatilites')
plt.legend(loc = 'upper left') #must show up otherwise label 'xxx' would show up
plt.xlabel('Date',fontsize=20)
plt.ylabel('Volatility')

ested_vol.plot(grid='on',color = '#32CD32',title='SH60000 volatility with estimated garch')


print('ested loglik=',loglik)
ested_vol.describe()
plt.show()
