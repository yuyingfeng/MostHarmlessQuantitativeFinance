function [liki,measurepredi,statepredi,varstatepredi,ypredic] = kalman_yyf(Phi,Ga,QQ,A,CC,GG,RR,y)
%==========================================================================
%   Kalman Filter                                                                  
%   This Function Implement the Kalman filter for the state space model:
%                        s = Phi*s(-1) + Ga*e            e~N(0,QQ)
%                        y = A + CC*s + GG*t + w         w~N(0,RR)
%  In the above system, y is an (ny*1) vector of observable variables and 
%  s is an ns*1 vector of latent variables. 
%
%  The Input of this function are the state space matrices and a ny*T vector 
%  of observations for y.  
%  
%  The Output is:
%   - measurepredi = the one step ahead prediction for y;
%   - liki = is a 1*T vector containing p(yt|Y1:t-1). The first entry is based  
%            on the prediction of the state vector at its unconditional
%            mean;
%   - statepredi = It is the prediction E[st|Y^(t)];
%   - varstatepredi = It is the MSE of the above prediction;
%==========================================================================

% Initialize the State Vector at the Stationary Distribution
[ny,T]     = size(y);
[ns,ns]    = size(Phi);
s          = zeros(ns,T+1);
P          = zeros(T+1,ns,ns);

%initialize s0|0 and P1|0
s(:,1)     = zeros(ns,1); 
P(1,:,:)   = ones(ns,ns);

a        = (inv(eye(ns*ns) - kron(Phi,Phi)))*(reshape(Ga*QQ*Ga',ns*ns,1));
P(1,:,:) = reshape(a,ns,ns); %P1|0

% Kalman Filter Recursion
sprime             = zeros(ns,1);
Pprime             = zeros(ns,ns);
errorprediction    = zeros(ny,T);
Varerrorprediction = zeros(T,ny,ny);
liki               = zeros(1,T);
measurepredi       = zeros(ny,T);

ypredic=zeros(ny,T);
for i=1:T
    
% Updating Step
sprime = Phi*s(:,i); 
Pprime = Phi*squeeze(P(i,:,:))*Phi' + Ga*QQ*Ga';

% Prediction Step
yprediction = A + GG*i + CC*sprime;

ypredic(:,i)=yprediction;

v = y(:,i) - yprediction;

F=CC*Pprime*CC'+RR; 
KGain(:,i)=Pprime*(CC')*(inv(F));

s(:,i+1)   = sprime + KGain(:,i)*v;

P(i+1,:,:) = Pprime - KGain(:,i)*CC*Pprime;

errorprediction(:,i) = v;
Varerrorprediction(i,:,:) = F;


liki(:,i) = -2*log(2*pi) -0.5*log(det(F)) - 0.5*v'*(inv(F))*v;


measurepredi(:,i) = y(:,i)-v;

end


statepredi = s;
varstatepredi = P;
 

end
