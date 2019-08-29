%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Lecturer :Marcus, Yingfeng, Yu
%  Copyright (c) 2014, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@live.com

clear all 
close all

load sp500_ibm_apple_90_14Apr03.mat

%from left 2 right-->from old days to today
SP500=flipud(sp500_900101_140403);
APP=flipud(apple_900101_140403);
IBM=flipud(ibm_900101_140403);


subplot(3,2,1)
%plot SP500
plot(SP500(:,2));
grid on
N=length(SP500(:,1));
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(SP500(1:intval:N,:),11))
title('SP 500 prices')
legend('SP500 price'); 

subplot(3,2,3)
plot(APP(:,2));
grid on
N=length(APP(:,1));
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(APP(1:intval:N,:),11))
title('Apple Stock prices')
legend('Apple price'); 

subplot(3,2,5)
plot(IBM(:,2));
grid on
N=length(IBM(:,1));
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(APP(1:intval:N,:),11))
title('IBM Stock prices')
legend('IBM price');

%plot hist returns

nbins=800;
%SP500 hist plot
subplot(3,2,2)
histfit(SP500(:,2),nbins,'normal');
%hist(SP500(:,2),nbins);
title('The histogram of SP500 index')

%APP hist plot
subplot(3,2,4)
histfit(APP(:,2),nbins,'normal')
title('The histogram of Apple prices')

%IBM hist plot
subplot(3,2,6)
histfit(IBM(:,2),nbins,'normal')
title('The histogram of IBM prices')

