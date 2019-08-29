function [ cvars,zs, rets, params,likelihood_val ] = NGarch11_yyf( Prices,dd,vals)
% NGarch11
%Warning: we accept prices as inputs
% input:

rets=diff(log(Prices));%find log returns of SP500 %PF Col C

NN=length(rets);

%sp_cvar=Asset 1's_Conditional_VARiance
cvars=var(rets) %initialize the first conditional variance

%initialized four parameters

alpha=vals(1);
beta=vals(2);
omega=vals(3);
theta=vals(4);

phi0=[alpha,beta,omega,theta];
options=optimset('MaxFunEvals',100000,'Maxiter',100000,'Display','iter','LargeScale','off');
[phi,likelihood_val]=fminsearch(@(phi)likfunc_levrgeff(phi,rets),vals);

 alpha=phi(1);
 beta=phi(2);
 omega=phi(3);
 theta=phi(4);

 params(1)=alpha;
 params(2)=beta;
 params(3)=omega;
 params(4)=theta; 
 
persistence=alpha*(1+theta^2)+beta;

if 1==0
display('|----------------------Asset 1------------------|')
display('|-----Names---------------------|Values-----|')
display(['|initial alpha------------------|',num2str(vals(1)),'|'])
display(['|initial beta-------------------|',num2str(vals(2)),'|'])
display(['|initial omega------------------|',num2str(vals(3)),'|'])
display(['|initial theta------------------|',num2str(vals(4)),'|'])
display('|----------------------------------------------------|')
display(['|estimated alpha----------------|',num2str( params(1)),'|'])
display(['|estimated beta-----------------|',num2str( params(2)),'|'])
display(['|estimated omega----------------|',num2str( params(3)),'|'])
display(['|estimated theta----------------|',num2str( params(4)),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])
display(['|Persistence--------------------|',num2str(persistence),'|'])
end

cvars=var(rets);
for i=2:NN
    cvars(i)=omega+alpha*(rets(i-1)-theta*sqrt(cvars(i-1)))^2+beta*cvars(i-1);
end
cvars=cvars';
zs=rets./sqrt(cvars);
end

