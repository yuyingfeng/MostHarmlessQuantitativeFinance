clear
close all
 
ST=50;%Terminal Stock price
K=40;
K1=35;
K2=45;
E=4;
T=1;
N_time=10;
dt=T/N_time;
N_sim=10;
r=0.05;
vol=0.25;
S0=ST*exp(-r*T);
 
iter=10; %Repeated experiment times
for mm=1:iter
        Ssim_T = simul_GBM(S0,r,vol,N_sim,N_time,T);
        %it is possible to vary different payoff functions
        CT_euc  = BSM_opt_payoff('c',Ssim_T, K);%euro call
        CT_eup  = BSM_opt_payoff('p',Ssim_T, K);%euro put
        CT_bus  = bullspread_payoff(Ssim_T,K1,K2);%bullspread
        CT_bes  = bearspread_payoff(Ssim_T,K1,K2);%bearspread
        CT_srd   = straddle_payoff(Ssim_T,K);%straddle
        CT_stg   = strangle_payoff(Ssim_T,K1,K2);%strangle
        CT_rvs   = riskreversal_payoff(Ssim_T,K1,K2);%riskreversal
        CT_bfy   =butterfly_payoff(Ssim_T,K,E);%butterfly
        CT_cnd  = condor_payoff(Ssim_T,K1,K2,E);%condor
        
        C_eucMC(mm)=exp(-r*T)*mean(CT_euc);%euro call
        C_eupMC(mm)=exp(-r*T)*mean(CT_eup);%euro put
        C_busMC(mm)=exp(-r*T)*mean(CT_bus);%bull spread
        C_besMC(mm)=exp(-r*T)*mean(CT_bes);%bear spread
        C_srdMC(mm)=exp(-r*T)*mean(CT_srd);%straddle
        C_stgMC(mm)=exp(-r*T)*mean(CT_stg);%strangle
        C_rvsMC(mm)=exp(-r*T)*mean(CT_rvs);%risk reversal
        C_bfyMC(mm)=exp(-r*T)*mean(CT_bfy);%butterfly
        C_cndMC(mm)=exp(-r*T)*mean(CT_cnd); %condor
end
 
q=0; %no dividen
%BSM pricing formula for all options mentioned
%in our chapter.
%euro call and put
[C_eucBS,C_eupBS]=blsprice(ST*exp(-r*T),K,r,T,vol,q);
 
%bull spread and bear spread
C_busBS= bullspread_bsm(ST,r,T,vol,q,K1,K2);
C_besBS= bearspread_bsm(ST,r,T,vol,q,K1,K2);
 
%straddle and strangle
C_srdBS= straddle_bsm(ST,r,T,vol,q,K);
C_stgBS= strangle_bsm(ST,r,T,vol,q,K1,K2);
 
%risk reversal
C_rvsBS= riskreversal_bsm(ST,r,T,vol,q,K1,K2);
 
%butterfly and condor
C_bfyBS= butterfly_bsm(ST,r,T,vol,q,K,E);
C_cndBS= condor_bsm(ST,r,T,vol,q,K1,K2,E);
