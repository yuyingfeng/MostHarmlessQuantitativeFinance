# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 17:17:41 2019

@author: 
"""

import numpy as np
import matplotlib.pyplot as plt
## if you use Jupyter Notebook, uncomment the following line
## %matplotlib inline

def european_opt_payoff(typ,S, K):
#typ ="type" when "c"=call, "p=put"
    if (typ=='c'):
        payoff=(abs(S-K)+(S-K))/2
    else:
        payoff=(abs(K-S)+(K-S))/2
    
    return payoff

S=np.arange(1,10,0.01) #underlying asset prices
K=5.0 #strike price
typ='c'
pay_off_c= european_opt_payoff(typ,S, K)
 
typ='p'
pay_off_p= european_opt_payoff(typ,S, K)

#xmin=min(S)
#xmax=max(S)
#ymin=min(-pay_off_c)
#ymax=max(pay_off_c)

plt.figure(figsize=(10,8))
plt.subplot(2,2,1)
#plt.axis([xmin,xmax,ymin,ymax])
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off_c,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Call')
plt.grid(True)

plt.subplot(2,2,3)
plt.axhline(0, color='black', lw=2)
plt.plot(S,-pay_off_c,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Call')
plt.grid(True)

plt.subplot(2,2,2)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off_p,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Put')
plt.grid(True)

plt.subplot(2,2,4)
plt.axhline(0, color='black', lw=2)
plt.plot(S,-pay_off_p,color = '#1B9E77', linewidth=1.5)
plt.title('Short a Put')
plt.grid(True)
