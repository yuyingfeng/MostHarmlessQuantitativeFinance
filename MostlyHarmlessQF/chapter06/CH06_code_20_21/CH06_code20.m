clear
close all
tic
ST=50;%Terminal Stock price
K=45;
T=1;
N_time=10e2;
dt=T/N_time;
N_sim=10e3;
r=0.05;
vol=0.25;
S(1)=ST*exp(-r*T);
S_T=zeros(N_sim,1);
for j=1:N_sim
    for i=1:N_time
        z=randn(1,1);
        S(i+1)=S(i)*exp((r-0.5*(vol^2))*dt+...
        vol*sqrt(dt)*z);
    end
    S_T(j)=S(end);
    C_T(j)= BSM_opt_payoff('c',S(end),K);
    P_T(j)= BSM_opt_payoff('p',S(end),K);
end
C_MC=exp(-r*T)*mean(C_T);
P_MC=exp(-r*T)*mean(P_T);
[C_bsm,P_bsm]=blsprice(ST*exp(-r*T),K,r,T,vol,0);
