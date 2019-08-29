import math as mh
import numpy as np
from time import time
import matplotlib.pyplot as plt

np.random.seed(20000)
t0=time();
S0=50;K=55;T=1.0;
r=0.05;sigma=0.2;M=50;
dt=T/M;I=250000

S=S0*np.exp(np.cumsum((r-0.5*sigma**2)*dt+sigma
                      *mh.sqrt(dt)*np.random.standard_normal((M+1,I)),axis=0))
S[0]=S0

C0=mh.exp(-r*T)*sum(np.maximum(S[-1]-K,0))/I

time_comsume=time()-t0
print('European Option Price=',C0)
print('Time used=',time_comsume,'(seconds)')


plt.subplot(2,2,1)
plt.subplot(2,2,2)
plt.subplot(2,1,1)
plt.plot(S[:,:100])
plt.grid(True)
plt.xlabel('Time Step')
plt.ylabel('Index Level')

plt.subplot(2,2,3)
plt.hist(S[-1],bins=50)
plt.grid(True)
plt.xlabel('Index Level')
plt.ylabel('Frequency')

plt.subplot(2,2,4)
plt.hist(np.maximum(S[-1]-K,0),bins=50)
plt.grid(True)
plt.xlabel('Index Level')
plt.ylabel('Frequency')

plt.show()
