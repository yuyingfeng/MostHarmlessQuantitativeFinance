%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

%  Description:% computes maximum likelhood estimates for a GARCH(1,1) process give
% timeseries "log_return(:,1)" using function fminsearch

function loglik=likfunc_levrgeff(phi,log_return)
%load PFQ1_1_result.mat
alpha=phi(1);
beta=phi(2);
omega=phi(3);
theta=phi(4);

% retrieve length of return series
NN=length(log_return(:,1));

% parameter restrictions: omega>0 alpha,beta>=0
 if omega<=0 || min(alpha,beta)<0;
        loglik=intmax;
        return;
 end

% ensure that GARCH(1,1) process is covariance-stationary
    denum=alpha*(1+theta^2)+beta;
    if denum>1;
      loglik=intmax;
      return;
    end
    
 % initialise vector holding the variance process
cond_var=var(log_return(:,1)); %initialize the first conditional variance
 % calculate squared returns
log_return2=log_return.^2;

 for i=2:NN    
        cond_var(i)=omega+alpha*(log_return(i-1,1)-theta*sqrt(cond_var(i-1)))^2+beta*cond_var(i-1);
 end
 
 loglik=0.5*(sum(log(cond_var')+(log_return2(:,1)./cond_var'))+NN*log(2*pi));
 
 % since sqrt(2*pi) is a constant factor it can be left out for maximum
 % likelihood purposes, hence, it is possible to rewrite the ML function as
 %    loglik=sum(log(cond_var')+(log_return2(:,1)./cond_var');
 