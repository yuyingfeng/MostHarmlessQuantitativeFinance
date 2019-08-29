# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 17:36:45 2019

@author: 
"""

import numpy as np
import matplotlib.pyplot as plt

# %matplotlib inline

def european_opt_payoff(typ,S, K):
#typ ="type" when "c"=call, "p=put"
    if (typ=='c'):
        payoff=(abs(S-K)+(S-K))/2
    else:
        payoff=(abs(K-S)+(K-S))/2
    
    return payoff


def binary_opt_payoff(typ,S, K, B):
#typ ="type" when "c"=call, "p=put"
    if (typ=='c'):
        payoff=B*(S>K)
    else:
        payoff=B*(S>K)
    return payoff

def bullspread_payoff(S,K1,K2):
    typ='c'
    payoff = european_opt_payoff(typ,S, K1)-european_opt_payoff(typ,S, K2)
    return payoff

def bearspread_payoff(S,K1,K2):
    typ='p'
    payoff = european_opt_payoff(typ,S, K2)-european_opt_payoff(typ,S, K1)
    return payoff

def straddle_payoff(S,K):
    payoff = european_opt_payoff('c',S, K)+european_opt_payoff('p',S, K)
    return payoff

def strangle_payoff(S,K1,K2):
    payoff = european_opt_payoff('c',S, K2)+european_opt_payoff('p',S, K1)
    return payoff

def riskreversal_payoff(S,K1,K2):
    payoff = european_opt_payoff('c',S, K2)-european_opt_payoff('p',S, K1)
    return payoff

def butterfly_payoff(S,K,E):
    payoff = european_opt_payoff('c',S, K-E)-2*european_opt_payoff('c',S, K)+ \
    european_opt_payoff('c',S, K+E)
    return payoff

def condor_payoff(S,K1,K2,E):
    payoff = european_opt_payoff('c',S, K1-E)- \
    european_opt_payoff('c',S, K1)- \
    european_opt_payoff('c',S, K2)+ \
    european_opt_payoff('c',S, K2+E)
    return payoff

cc=8
rr=2

S=np.arange(1,15,0.01) #underlying asset prices
K1=3.0 #strike price
K2 =12.0
typ='c'
pay_off = bullspread_payoff(S, K1, K2)
 
plt.figure(figsize=(10,30))
plt.subplot(cc,rr,1)
#plt.axis([xmin,xmax,ymin,ymax])
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Bull Spread')
plt.grid(True)

S=np.arange(0,15,0.01) #underlying asset prices
K1=3 #strike price
K2=12 #strike price
pay_off = bearspread_payoff(S,K1,K2);

plt.subplot(cc,rr,2)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Bear Spread')
plt.grid(True)

S=np.arange(0,10,0.01) #underlying asset prices
K =5 #strike price

pay_off = straddle_payoff(S,K)

plt.subplot(cc,rr,3)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Stradlle')
plt.grid(True)

plt.subplot(cc,rr,4)
plt.axhline(0, color='black', lw=2)
plt.plot(S,-pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Short a Stradlle')
plt.grid(True)

S=np.arange(0,10,0.01) #underlying asset prices
K1 = 8.0 #strike price
K2 = 5.0 #strike price
pay_off = strangle_payoff(S,K1,K2)
plt.subplot(cc,rr,5)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('In-the-Money Strangle Option')
plt.grid(True)

S=np.arange(0,10,0.01) #underlying asset prices
K1 = 5.0 #strike price
K2 = 8.0 #strike price
pay_off = strangle_payoff(S,K1,K2)
plt.subplot(cc,rr,6)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Out-of-Money Strangle Option')
plt.grid(True)

S=np.arange(0,10,0.01) #underlying asset prices
K1 = 3.0 #strike price
K2 = 8.0 #strike price
if K1>=K2:
    print('Sorry, it is improper setting')
else:
    pay_off = riskreversal_payoff(S, K1, K2)
    
plt.subplot(cc,rr,7)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Risk Reversal Option')
plt.grid(True)

plt.subplot(cc,rr,8)
plt.axhline(0, color='black', lw=2)
plt.plot(S,-pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Short a Risk Reversal Option')
plt.grid(True)

S=np.arange(5,15,0.01) #underlying asset prices
K = 10.0 #strike price
E = 4.0 #strike price
if E>K:
    print('Sorry, it is improper setting')
else:
    pay_off = butterfly_payoff(S, K, E)
    
plt.subplot(cc,rr,9)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Butterfly Option')
plt.grid(True)

S=np.arange(0,15,0.01) #underlying asset prices
K1 = 6.0 #strike price
K2 = 10.0
E = 4.0 #strike price
if ((E>K)or(K1>K2)or(E>K2)):
    print('Sorry, it is improper setting')
else:
    pay_off = condor_payoff(S, K1, K2, E)
    
plt.subplot(cc,rr,10)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Condor Option')
plt.grid(True)
