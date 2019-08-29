%main function
Rdc=1/100;
Rfc=3/100;
T=365;
S0=1.0625;
Fmkt=1.0800;
 
[prof, initial_currency]=CoveredIntArbitrage(S0,Fmkt,Rdc,Rfc,T)
