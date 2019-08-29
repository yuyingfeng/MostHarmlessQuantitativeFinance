function [prof,initial_currency]=CoveredIntArbitrage(S0,Fmkt,Rdc,Rfc,T)
% input: S0, spot rate
%           Fmkt, FX forward market price
%           Rdc, Domestic interest rate
%           Rfc, Foreign interest rate
%           T, the maturity of FX forward
%output: prof, profit investor earned
%            initial_currency: Initially, the currency investor should
%            lend from bank
F=PriceFXForward(S0, Rdc,Rfc,T);
if F<Fmkt
    prof =1000*((Fmkt/S0)*(1+Rfc)^(T/365)-(1+Rdc)^(T/365));
    initial_currency='DC';
else
    prof =1000*((S0/Fmkt)*(1+Rdc)^(T/365)-(1+Rfc)^(T/365));
    initial_currency='FC';
end
