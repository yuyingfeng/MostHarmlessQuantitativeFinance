function BAWAericanCall =BAWAericanCallApprox(S,X,T,t,r,b,vol) 

if b >=r
    C_bsm=bsm_call(S,X,T,t,r,b,vol);
    BAWAericanCall = C_bsm;
else
    tau=T-t;
    %Using Newton-Raphson method to solve
    %non-linear equation
    S_star=critical_S(X,tau,r,b,vol);
    N= 2*b/(vol^2);
    M= 2*r/(vol^2);
    h = 1-exp(-r*tau);
    d1=((log(S_star/X))+(b+(vol^2)/2)*tau)/(vol*sqrt(tau));
    gamma_2=(-(N-1)+sqrt((N-1)^2+4*M/h))/2;
    A2=(S_star/gamma_2)*(1-exp((b-r)*tau))*normcdf(d1,0,1);
    if S<S_star
        C_bsm=bsm_call(S,X,T,t,r,b,vol);
        BAWAericanCall = C_bsm+A2*(S/S_star)^gamma_2;
    else
        BAWAericanCall =S-X;
    end
end

