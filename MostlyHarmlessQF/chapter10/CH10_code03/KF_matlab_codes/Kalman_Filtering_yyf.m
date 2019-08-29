%construct SS format
%apply Kalman Filter to find the optimal state estimation
%using the optmial state estimation results to construct y_prediction
%This demo has nothing to do with parameters estimation
clear 
load ./yyfQFdata/y
load ./yyfQFdata/paramAR2

delta_ar2=Theta(1);

phi1=Theta(2);
phi2=Theta(3);
sigma=Theta(4);

PHI=[phi1 phi2;1 0];
Ga=[1;0];
QQ=sigma;

A=delta_ar2;
CC=[1 0]; 
GG=0;
RR=0;


[liki,measurepredi,statepredi,varstatepredi,ypredic] = kalman_yyf(PHI,Ga,QQ,A,CC,GG,RR,y);

subplot(2,1,1)
plot(ypredic(2:end))
hold on
plot(y(1:end-1),'r-.');
legend('only KF','real data')
title('AR(2) Kalman Restuls')

N=length(y(1,:));

ypred_error(1)=sum((ypredic(2:end)-y(1:end-1)).^2)/(N-1);
save ./yyfQFdataout/filtered_y_error.mat ypred_error;
display(['|--filtered y errors--|',num2str(ypred_error),'|--------------'])
