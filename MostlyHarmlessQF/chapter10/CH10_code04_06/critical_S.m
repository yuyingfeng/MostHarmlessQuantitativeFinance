function S_star=critical_S(X,T,r,b,v)
N=      2*b/(v^2);
M=      2*r/(v^2);
q2u=    (-(N-1)+sqrt((N-1)^2+4*M))/2;
su=     X/(1 -1/q2u);
h2=     -(b*T+2*v*sqrt(T))*X/(su-X);
Si=     X+(su-X)*(1-exp(h2));

M_h=  (2*r)/((v^2)*(1-exp(-r*T)));
d1=     (log(Si/X)+(b+(v^2)/2)*T)/(v*sqrt(T));
gamma2=(-(N-1)+sqrt((N-1)^2+4*M_h))/2;
LHS =   Si -X;
RHS =   bsm_call(Si,X,T,0,r,b,v)+(1-exp((b-r)*T))*normcdf(d1,0,1)*Si/gamma2;
bi=exp((b-r)*T)*normcdf(d1,0,1)*(1-1/gamma2)+(1-exp((b-r)*T)*normcdf(d1,0,1)/(v*sqrt(T)))/gamma2;
E=1e-12;
err=abs(LHS-RHS)/X;
    while err>E
       Si = (X+LHS -bi*Si)/(1-bi);
       d1 = (log(Si)/X)+(b+(v^2)/2)*T/(v*sqrt(T));
       RHS = Si -X;
       LHS = bsm_call(Si,X,T,0,r,b,v)+(1-exp((b-r)*T))*normcdf(d1,0,1)*Si/gamma2;
       bi=exp((b-r)*T)*normcdf(d1,0,1)*(1-1/gamma2)+(1-(exp((b-r)*T)*normpdf(d1,0,1)/(v*sqrt(T))))/gamma2;
       err=abs(LHS-RHS)/X;
    end
S_star=Si;
end

