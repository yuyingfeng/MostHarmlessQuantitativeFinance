clear
close all
tic
S0=10; %Initial Stock price
T=10;
N_time=10e3;
dt=T/N_time;
N_sim=10e2;
t=[0.0:dt:T];
mu=0.05;
vol=0.25;
S=zeros(N_sim,N_time+1);
S(:,1)=S0*ones(N_sim,1);
 
subplot(1,2,1)
hold on
 
 for j=1:N_sim
     for i=1:N_time
         z=randn(1,1);
        S(j,i+1)=S(j,i)*exp((mu-0.5*(vol^2))*dt+...
         vol*sqrt(dt)*z);
     end
     plot(t,S(j,:));
 end
mu_s=S0*exp(mu*t);
vol_s=S0*exp(mu*t).*sqrt(exp((vol^2)*t)-1);
plot(t,mu_s,'k');
plot(t,mu_s+vol_s,'.k');
plot(t,mu_s-vol_s,'.k');
xlabel('time')
ylabel('S_{t}')
title('Simulated geometric Brownian Montion')
grid on
 
nBins=100;
subplot(1,2,2)
hold on
grid on
histfit(S(:,end),nBins, 'lognormal');
set(gca, 'xdir', 'reverse')
camroll(270)
xlabel('S_{T}')
ylabel('frquencies')
title('The histogram of S_{T} with LogNomral fit')
 
 
figure
sample_mean_S=mean(S(:,1:end));
sample_std_S=std(S(:,1:end));
 
plot(t,sample_mean_S,'.k');
hold on
plot(t,mu_s);
 
plot(t,sample_mean_S+sample_std_S,'+r');
plot(t,sample_mean_S-sample_std_S,'+r');
 
plot(t,mu_s+vol_s,'.-k');
plot(t,mu_s-vol_s,'.-k');
 
grid on
xlabel('Time')
ylabel('S_{t}')
legend('Simluated sample mean of S_{t}^{i}',...
    'Theoretical mean of S_{t}',...
    'Simulated sample +std','Simulated sample -std',...
    'Theoretical +std', 'Theoretical -std')
title('Simulated sample moments vs theoretical momnets')
toc
