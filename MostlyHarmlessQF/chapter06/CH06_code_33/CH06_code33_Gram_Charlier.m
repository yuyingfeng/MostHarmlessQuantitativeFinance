% Gram-Charlier Call option pricing 
clear
sigma=0.12;
xi11=0.023;
xi21=3.2;
rf=0.03;%
T=1;
t=0.5;
S=50;
K=45;
dT=T-t;

d1=log(S/K)+dT*(rf+0.5*sigma^2)/(sigma*sqrt(dT));
d2=d1-sqrt(dT)*sigma;
call_BSM=S*normcdf(d1)-K*exp(-rf*dT)*normcdf(d2);
tmp1=xi11*(2*sqrt(dT)*sigma-d1)/6;
tmp2=xi21*(1-d1^2+3*d1*sqrt(dT)*sigma-3*dT*sigma^2)/(24*sqrt(dT));
call_GC=call_BSM+S*normpdf(d1)*sigma*(tmp1-tmp2);
