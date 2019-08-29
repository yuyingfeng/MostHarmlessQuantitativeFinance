%draw N(0,1) pdf graph
x=[-6:0.01:6];
pf=normpdf(x,0,1);
plot(x,pf);
 
p=99/100;
sigma_t=0.00135;
%let p=1-0.01, 
%and treat sigma_t as a constant which equals to 0.00135
% and then VaR should be:
VaR=-sigma_t*norminv(1-p);
dollar_VaR=1-exp(VaR);
