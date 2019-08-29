import numpy as np
import pandas as pd
import scipy.stats as ss
import matplotlib.pyplot as plt
from scipy.optimize import fmin_slsqp

#class yyfQuantFin:
    #def __init__(self):
#def fib(n):
#   a, b =0,1
#   while b< n:
#       print ('b')
#       b = b+2

def CtCHV(data, N, out = None):
    ###---------------
    # input: data : format must be PANDAS
    #        N : historial window
    #        out: assume using log diff returns
    # output std_CtC
    ###-----------
    if out is None:
        dfrets = np.log(data/data.shift(1)).dropna()
        print('running log diff returns')
    else:
        dfrets = data.pct_change().dropna()
        print('running pct_change returns')

    T = np.size(dfrets,0)
    print(T)
    std_CtC=np.zeros((T-N,1))
    for t in range(0,T-N):
        std_CtC[t]=dfrets[t:t+N].std()

    return std_CtC

def GermanKlassHV(HDD,LDD,ODD,CDD, N):
        un = np.log(HDD/ODD)
        dn = np.log(LDD/ODD)
        cn = np.log(CDD/ODD)
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

def parkinsonHV(HDD, LDD, ODD, N):
        un = np.log(HDD/ODD)
        dn = np.log(LDD/ODD)

        T = np.size(HDD,0)
        std_park=np.zeros((T-N,1))
        for i in range(0,T-N):
            std_park[i]=np.sqrt((1/(4*N*np.log(2)))*np.sum((un[i:i+N]-dn[i:i+N])**2))

        return std_park

def RogersSatchellHV(HDD,LDD,ODD,CDD, N):
        un = np.log(HDD/ODD)
        dn = np.log(LDD/ODD)
        cn = np.log(CDD/ODD)

        T = np.size(HDD,0)
        std_rs=np.zeros((T-N,1))
        for i in range(0,T-N):
            tmp=un[i:i+N]*(un[i:i+N]-cn[i:i+N])+dn[i:i+N]*(dn[i:i+N]-cn[i:i+N]);
            std_rs[i]=np.sqrt(np.mean(tmp));

        return std_rs
