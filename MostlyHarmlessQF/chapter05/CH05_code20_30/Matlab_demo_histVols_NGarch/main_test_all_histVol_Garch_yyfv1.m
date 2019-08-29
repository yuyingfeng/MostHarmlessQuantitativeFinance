%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015,Dec,29, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and Macroeconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn
%  Description: demonstrate how to use different historical volatilities
%  and NGarch(1,1)
 
clear all
close all
 
load test_SH600000.mat
%after you load this mat file ,you will retrieve the following data
%    'stk_dates' represents  stock date information
%    'ODD'  represents open price
%    'HDD' represents high
%    LDD represents low
%    CDD  represents close
%    StockName as it indicates
%define different methods %please check my notes or Bloomberg Historical
%volatility definitions

diff_mtds={'CtC','Parkinson','Garman-Klass','Rogers-Satchell','NGarch'};
% now I demonstrate how NGarch(1,1) works
val(1)=0.03;%alpha
val(2)=0.97;%beta
val(3)=0.000005;%omega
val(4)=0.0000000000000000001;%theta 
 
%my new "NGarch11" function is more automatic than previous version, my fun
%directly accept prices instead of log-returns
%'stk' represents "stock"
%'cvars'=conditional variances
%'zs"=standardized returns
[stk_cvars,stk_zs,stk_rets,stock_params,likival] = NGarch11_yyf(CDD,stk_dates,val);
stk_cstds=sqrt(stk_cvars);
        
display('|-----------Estimated NGarch parameters Results------------------|')
display('|-----Names---------------------|Values-----|')
display(['|initial alpha------------------|',num2str(val(1)),'|'])
display(['|initial beta-------------------|',num2str(val(2)),'|'])
display(['|initial omega------------------|',num2str(val(3)),'|'])
display(['|initial theta------------------|',num2str(val(4)),'|'])
 
display('|----------------------------------------------------|')
display(['|estimated alpha----------------|',num2str(stock_params(1)),'|'])
display(['|estimated beta-----------------|',num2str(stock_params(2)),'|'])
display(['|estimated omega----------------|',num2str(stock_params(3)),'|'])
display(['|estimated theta------------------|',num2str(stock_params(4)),'|'])
display(['|Log likelihood-----------------|',num2str(-likival),'|'])
%I finish demonstration of NGrach(1,1)
 
%now I start demonstrating four different calculation methods of historical
%volatilities

len=length(stk_dates);
N=30;
std_CtC     = CtCHV(CDD,N); %call CtCHV func
std_park    = parkinsonHV(HDD,LDD,ODD,N);
std_gk      = GarmanKlassHV(HDD,LDD,ODD,CDD,N);
std_rs      = RogersSatchellHV(HDD,LDD,ODD,CDD,N);


subplot(3,2,1)
intval=360;%interval, set as 1 year
len1=length(CDD);
plot(CDD);
grid on
xlim([0 len1]);
set(gca,'XTick',[1:intval:len1]);
set(gca,'XTickLabel',datestr(stk_dates(N+2:intval:end,1),11));
title([StockName,'close price'])

subplot(3,2,2)
len2=length(std_CtC);
plot(std_CtC);
grid on
xlim([0 len2]);
set(gca,'XTick',[1:intval:len2]);
set(gca,'XTickLabel',datestr(stk_dates(N+1:intval:end,1),11));
title([diff_mtds{1},' historical Vols']);

subplot(3,2,3)
plot(std_park);
grid on
xlim([0 len2]);
set(gca,'XTick',[1:intval:len2]);
set(gca,'XTickLabel',datestr(stk_dates(N+1:intval:end,1),11));
title([diff_mtds{2},' historical Vols']);

subplot(3,2,4)
plot(std_gk);
grid on
xlim([0 len2]);
set(gca,'XTick',[1:intval:len2]);
set(gca,'XTickLabel',datestr(stk_dates(N+1:intval:end,1),11));
title([diff_mtds{3},' historical Vols']);

subplot(3,2,5)
plot(std_rs);
grid on
xlim([0 len2]);
set(gca,'XTick',[1:intval:len2]);
set(gca,'XTickLabel',datestr(stk_dates(N+1:intval:end,1),11));
title([diff_mtds{4},' historical Vols']);

subplot(3,2,6)
plot(stk_cstds);
grid on
xlim([0 len]);
set(gca,'XTick',[2:intval:len]);
set(gca,'XTickLabel',datestr(stk_dates(2:intval:end,1),11));
title([diff_mtds{5},'11 Vols']);

