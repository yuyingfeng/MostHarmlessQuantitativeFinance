%main function
Rdc=1/100;
Rfc=3/100;
T=365;
S0=1.0625;
%Pricing FX forward 
F= PriceFXForward(S0, Rdc,Rfc,T)
%After 180 days, valuing Vt(F0:T)
t=180;
St=1.1;
Val= ValueFXForward(St, F, Rdc,Rfc,T,t)
