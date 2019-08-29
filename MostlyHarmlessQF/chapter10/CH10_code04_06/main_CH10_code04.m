clear 
close all
format long;
S=50;%underlying asset price
T=0.5;%contract maturity
vol=0.35;%annually volatility
X=60;%strike price
r=0.2;%risk-free rate
q=0.1;%compounded discount rate
b=r-q;
t=.0;
 
C_am=BAWAericanCallApprox(S,X,T,t,r,b,vol)
C_bsm=bsm_call(S,X,T,t,r,b,vol)
