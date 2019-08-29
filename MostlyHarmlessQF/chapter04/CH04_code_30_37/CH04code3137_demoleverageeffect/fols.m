function results=fols(y,x)
% PURPOSE: least-squares regression 
%---------------------------------------------------
% USAGE: results = ols(y,x)
% where: y = dependent variable vector (nobs x 1)
%        x = independent variables matrix (nobs x nvar)
%---------------------------------------------------
% RETURNS: a structure
%        results.math  = 'ols'
%        results.beta  = bhat
%        results.tstat = t-stats
%        results.yhat  = yhat
%        results.resid = residuals
%        results.sige  = e'*e/(n-k)
%        results.rsqr  = rsquared
%        results.rbar  = rbar-squared
%        results.dw    = Durbin-Watson Statistic
%        results.nobs  = nobs
%        results.nvar  = nvars
%        results.y     = y data vector

if (nargin ~= 2); error('Wrong # of arguments to ols'); 
else
 [nobs nvar] = size(x); [nobs2 junk] = size(y);
 if (nobs ~= nobs2); error('x and y must have same # obs in ols'); 
 end;
end;

results.math = 'ols';
results.y = y;
results.nobs = nobs;
results.nvar = nvar;

[q r] = qr(x,0);
xpxi = (r'*r)\eye(nvar);

results.beta = r\(q'*y);
results.yhat = x*results.beta;
results.resid = y - results.yhat;
sigu = results.resid'*results.resid;
results.sige = sigu/(nobs-nvar);
tmp = (results.sige)*(diag(xpxi));
results.tstat = results.beta./(sqrt(tmp));
ym = y - mean(y);
rsqr1 = sigu;
rsqr2 = ym'*ym;
results.rsqr = 1.0 - rsqr1/rsqr2; % r-squared
rsqr1 = rsqr1/(nobs-nvar);
rsqr2 = rsqr2/(nobs-1.0);
results.rbar = 1 - (rsqr1/rsqr2); % rbar-squared
ediff = results.resid(2:nobs) - results.resid(1:nobs-1);
results.dw = (ediff'*ediff)/sigu; % durbin-watson
results.RootMSE=sqrt(results.sige);
