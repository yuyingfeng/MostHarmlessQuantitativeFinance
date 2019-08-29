from time import time
import math as mh 
import random as rd 

rd.seed(20000)
t0=time()
S0=50.00;K=55.00;T=1.0
r=0.05;sigma=0.2;M=50
dt=T/M;Iter=300000

S=[]
for i in range(Iter):
    path=[]
    for t in range(M+1):
        if t==0:
            path.append(S0)
        else:
            z = rd.gauss(0.0,1.0)
            St= path[t-1]*mh.exp((r-0.50*(sigma**2))*dt+sigma*mh.sqrt(dt)*z)
            path.append(St)
    S.append(path)

sum_val=0.0
for path in S:
    sum_val = sum_val+max(path[-1]-K,0)

C0=mh.exp(-r*T)*sum_val/Iter

time_comsume=time()-t0
print("European Option Price=",C0)
print("Time used=",time_comsume,"(seconds)")



