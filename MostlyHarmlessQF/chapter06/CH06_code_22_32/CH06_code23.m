clear
close all
 
ST=50;%Terminal Stock price
K1=35;
K2=45;
T=1;
N_time=10e1;
dt=T/N_time;
N_sim=20e2;
r=0.05;
vol=0.25;
S0=ST*exp(-r*T);
 
iter=500;
for mm=1:iter
        Ssim_T = simul_GBM(S0,r,vol,N_sim,N_time,T);
        %it is possible to vary different payoff functions
        C_T=bullspread_payoff(Ssim_T,K1,K2);
        C_MC(mm)=exp(-r*T)*mean(C_T);
end
 
%BSM pricing formula for bullspread call option
C1_bsm=blsprice(ST*exp(-r*T),K1,r,T,vol,0);
C2_bsm=blsprice(ST*exp(-r*T),K2,r,T,vol,0);
C_bullspread_bsm=C1_bsm-C2_bsm;
err=sum((C_MC(mm)-C_bullspread_bsm).^2)/iter;
 
%plot results
C_theoVal=C_bullspread_bsm*ones(iter,1);
hold on;
plot(C_theoVal,'^-');
grid on
plot(C_MC,'.','markersize', 25);
legend('theoretical result','simulation results');
