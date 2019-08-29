function Val= ValueFXForward(St, F, Rdc,Rfc,T,t )
    % valuation of Vt(F0:T)
    Val=St/(1+Rfc)^((T-t)/365)-F/(1+Rdc)^((T-t)/365);
end
