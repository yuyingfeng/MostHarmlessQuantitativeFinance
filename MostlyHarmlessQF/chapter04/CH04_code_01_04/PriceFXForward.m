function F= PriceFXForward(S0, Rdc,Rfc,T)
    % Pricing FX forward
    F=S0*((1+Rdc)/(1+Rfc))^(T/365);
end