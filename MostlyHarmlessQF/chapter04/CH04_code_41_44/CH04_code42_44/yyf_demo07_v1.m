%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business
%  School of Finance, Dept. of International Finance
%  Lecturer :Marcus, Yingfeng, Yu
%  Using SP500 data to demonstrate how to calculate MC VaR
%  Copyright (c) 2013, Yingfeng Yu
%  All rights reserved.

clear all;
close all;
load R_sp;
alpha=0.94;
beta=0.06;
iter=500; %MCMC iteration 
nBins=100; %histogram usage
for j=1:iter
  for i=1:11 %day
           if i==1
                sp_std(j,i)=std(R_sp);
                sp_R(j,1)=mean(R_sp);
                sp_price(j,1)=2114.28;%price S0=2114.28
           else
               sp_std(j,i)=sqrt(alpha*sp_std(j,i-1)^2+beta*sp_R(j,i-1)^2);
               sp_R(j,i)=sp_std(j,i)*randn(1,1);
               sp_price(j,i)=sp_price(j,i-1)*exp(sp_R(j,i));
           end
  end
end
figure(1);

% tmp demo
sp_R10d=sum(sp_R(:,2:11),2);
histfit(sp_R10d,nBins);
VaR= -prctile(sp_R10d,1)
% tmp demo ends


% for constructing video
rect=get(gcf,'Position'); rect(1:2)=[0,0];%ignore
t=1:11;
sp_R10d=sum(sp_R(:,2:11),2);%think! why I use 'sum' instead of average?
for i=1:iter
    subplot(2,2,3)
    hold on %ignore
    grid on %ignore
      plot(sp_R(i,:));
      xlabel('days');
      ylabel('stock expected return')
      axis([1 11 -0.06 0.06]) %ignore
      hold off %ignore
      subplot(2,2,4)
        if i>nBins
                histfit(sp_R10d(1:i),nBins);
                set(gca, 'xdir', 'reverse');%ignore
                camroll(270)%ignore
                xlabel('stock expected return')
                ylabel('frquencies')
        else
            if i==1
            else 
                histfit(sp_R10d(1:i),nBins);
                set(gca, 'xdir', 'reverse');%ignore
                camroll(270)
                xlabel('stock expected return')
                ylabel('frquencies')
            end
        end
        subplot(2,2,1)
            hold on%ignore
            grid on%ignore
            plot(sp_price(i,:));
            xlabel('days');
            ylabel('expected stock price')
            axis([1 11 1800 2500])%ignore
            hold off%ignore
        subplot(2,2,2)
        if i>nBins
            histfit(sp_price(1:i,11),nBins);
            set(gca, 'xdir', 'reverse');
            camroll(270)
            xlabel('expected stock price')
            ylabel('frquencies')
        else
            if i==1
            else
            histfit(sp_price(1:i,11),nBins);
            set(gca, 'xdir', 'reverse');
            camroll(270)
            xlabel('stock expected return')
             ylabel('frquencies')
            end
        end
   
        frame(:,i)=getframe(gcf,rect);%recoard video //ignore
end
hold off
break

movie2avi(frame,'example4.avi');%create video file

close all
figure
sp_R10d=sum(sp_R(:,2:11),2);
histfit(sp_R10d,nBins);
VaR= -prctile(sp_R10d,1)

display('|--------------Statistical Properties-----------|')
display('|name----------------|mean------|variance--|skewness|kurtosis|')
display(['|MC#1000 10d Rt--|',num2str(mean(sp_R10d)),'|',num2str(var(sp_R10d)),'|',num2str(skewness(sp_R10d)),'|',num2str(kurtosis(sp_R10d)),'|'])


