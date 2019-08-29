clear 
close
 
load sp500_ibm_apple_90_14Apr03.mat
 
%from left 2 right-->from old days to today
SP500=flipud(sp500_900101_140403);
APP=flipud(apple_900101_140403);
IBM=flipud(ibm_900101_140403);
 
R_SP500=diff(log(SP500(:,2)));
R_APP=diff(log(APP(:,2)));
R_IBM=diff(log(IBM(:,2)));
 
%%plot return
 
%SP500 log-return
subplot(3,3,1)
plot(R_SP500);
grid on
N=length(R_SP500);
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(SP500(1:intval:N,:),11))
title('SP500 index logReturn')
%legend('SP500 logReturn'); 
 
%APPLE log-return
subplot(3,3,4)
plot(R_APP);
grid on
N=length(R_APP);
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(APP(1:intval:N,:),11))
title('APP logReturn')
%legend('APP logReturn');
 
%IBM log-return
subplot(3,3,7)
plot(R_IBM);
grid on
N=length(R_IBM);
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(IBM(1:intval:N,:),11))
title('IBM logReturn')
%legend('IBM logReturn');
 
%plot hist returns
nbins=800;
%SP500 hist plot
subplot(3,3,2)
histfit(R_SP500,nbins,'normal');
%hist(SP500(:,2),nbins);
title('The histogram of SP500 index')
 
%APP hist plot
subplot(3,3,5)
histfit(R_APP,nbins,'normal')
title('The histogram of Apple prices')
 
%IBM hist plot
subplot(3,3,8)
histfit(R_IBM,nbins,'normal')
title('The histogram of IBM prices')
 
%plot qq plot test
%SP500 qq plot
subplot(3,3,3)
qqplot(R_SP500);
title('The QQ plot of R_SP500')
 
%APP qq plot
subplot(3,3,6)
qqplot(R_APP);
title('The QQ plot of R_Apple')
 
%IBM qq plot
subplot(3,3,9)
qqplot(R_IBM);
title('The QQ plot of R_IBM')
 
 
display('|--------------Statistical Properties-----------|')
display('|name---|mean------|variance--|skewness|kurtosis|')
display(['|SP500--|',num2str(mean(R_SP500)),'|',num2str(var(R_SP500)),'|',num2str(skewness(R_SP500)),'|',num2str(kurtosis(R_SP500)),'|'])
display(['|APPLE--|',num2str(mean(R_APP)),'|',num2str(var(R_APP)),'|',num2str(skewness(R_APP)),'|',num2str(kurtosis(R_APP)),'|'])
display(['|IBM----|',num2str(mean(R_IBM)),'|',num2str(var(R_IBM)),'|',num2str(skewness(R_IBM)),'|',num2str(kurtosis(R_IBM)),'|'])
