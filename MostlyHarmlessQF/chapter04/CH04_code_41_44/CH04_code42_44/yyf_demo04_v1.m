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
Returns      = [0.1 0.15 0.12 0.22];
STDs         = [0.2 0.25 0.18 0.22];

Correlations = [ 1  0.3  0.4 0.5
                0.3  1   0.3 0.2
                0.4 0.3   1  0.45 
                0.5 0.2   0.45   1
                ];
            
Covariances = corr2cov(STDs, Correlations);

nobs=200; %generates nobs pts on frontier 
portopt(Returns, Covariances, nobs);



Weights = rand(100000, 4);
ndim=2;
Total = sum(Weights, ndim);  % Add the weights?in ?sum(..,2)?2 represents dim
Total = Total(:,ones(4,1));  % Make size-compatible matrix
Weights = Weights./Total;    % Normalize so sum = 1

[PortRisk, PortReturn] = portstats(Returns, Covariances, ...
                         Weights);
                     
hold on
plot (PortRisk, PortReturn, '.r')
title('Mean-Variance Efficient Frontier and Random Portfolios')
hold off 