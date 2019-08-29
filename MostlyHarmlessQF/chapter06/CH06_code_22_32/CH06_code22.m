clear
close all
 
ST=50;%Terminal Stock price
K1=35;
K2=45;
T=1;
N_time=10e2;
dt=T/N_time;
N_sim=10e4;
r=0.05;
vol=0.25;
S(1)=ST*exp(-r*T);
S_T=zeros(N_sim,1);
iter=20;
for mm=1:iter
    for j=1:N_sim
        for i=1:N_time
            z=randn(1,1);
            S(i+1)=S(i)*exp((r-0.5*(vol^2))*dt+...
            vol*sqrt(dt)*z);
        end
        S_T(j)=S(end);
        C_T(j)=bullspread_payoff(S(end),K1,K2);
    end
C_MC(mm)=exp(-r*T)*mean(C_T);
end
 
%BSM pricing formula for bullspread call option
C1_bsm=blsprice(ST*exp(-r*T),K1,r,T,vol,0);
C2_bsm=blsprice(ST*exp(-r*T),K2,r,T,vol,0);
C_bullspread_bsm=C1_bsm-C2_bsm;
err=sum((C_MC(mm)-C_bullspread_bsm).^2)/iter;
 
%plot results
hold on;
plot(C_bullspread_bsm,'^-');
grid on
plot(C_MC,'.','markersize', 25);
legend('theoretical result','simulation results');
