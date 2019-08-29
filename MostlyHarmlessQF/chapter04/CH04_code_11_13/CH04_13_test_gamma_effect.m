%test_gamma_effect.m
clear 
close all
S=50;
K=50;
r=0.1;% risk-free rate
T=5/12;
vol=0.3; %volatility
 
C0=blsprice(S,K,r,T,vol);
ds=2;%stock price increment
C1=blsprice(S+ds,K,r,T,vol)
delta=blsdelta(S,K,r,T,vol);
gamma=blsgamma(S,K,r,T,vol);
approx_1strd_C=C0+delta*ds
