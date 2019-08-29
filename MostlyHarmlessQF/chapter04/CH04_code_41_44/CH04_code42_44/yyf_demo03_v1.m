%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Lecturer :Marcus, Yingfeng, Yu
%  Copyright (c) 2014, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@live.com

close all
clear all

load sp500_ibm_apple_90_14Apr03.mat

%from left 2 right-->from old days to today
%SP500=flipud(sp500_900101_140403);
APP=flipud(apple_900101_140403);
IBM=flipud(ibm_900101_140403);

%R_SP500=diff(log(SP500(:,2)));
R_APP=diff(log(APP(:,2)));
R_IBM=diff(log(IBM(:,2)));

Ind_Rts =[mean(R_APP) mean(R_IBM)];%Individual Returns vector
Ind_Stds=[std(R_APP) std(R_IBM)];%Individual assets stds vector

Ind_Corr =corr([R_APP,R_IBM]);%individual assets'correlation matrix
            
Ind_Cov = corr2cov(Ind_Stds,Ind_Corr);%contruct covariance matrix with corr matrix and stds

nobs=2000; %generates nobs pts on frontier 
%plot 'frontier' -->blue line
portopt(Ind_Rts, Ind_Cov, nobs);

nass=length(Ind_Rts(1,:));%the number of assets--in this demo,two assets
ww = rand(100000,nass);

Total_ww = sum(ww, 2);  % Add the weights?in ?sum(..,2)?2 represents dim
Total_ww = Total_ww(:,ones(nass,1));  % Make size-compatible matrix
ww = ww./Total_ww;    % Normalize so sum = 1

[PortRisk, PortReturn] = portstats(Ind_Rts,Ind_Cov,ww);                
hold on
plot (PortRisk, PortReturn, '.r')

%hold off 
%plot some special weights
ww2=[1,0;0.8,0.2;0.6,0.4;0.4,0.6;0.2,0.8;0,1];
[PortRisk, PortReturn] = portstats(Ind_Rts,Ind_Cov,ww2);

plot(PortRisk, PortReturn, '.k')
title('Mean-Variance Efficient Frontier and Random Portfolios')
hold off 