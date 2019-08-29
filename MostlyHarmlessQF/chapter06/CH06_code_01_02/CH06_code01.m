clear all
close
S0=10;
t0=[-1.0:0.01:1.0];%time scale for  roon   roon  n  on
t1=[1.5:0.01:25];%time scale for St
t2=[1.5:0.01:4.0];%time scale for log(St)
mu=0.06;
sigma=0.2;
Y=normpdf(t0,mu,sigma);
 
%plot the norm pdf
subplot(3,1,1)
hold on
grid on
plot(t0,Y)
xlabel('N(\mu,\sigma),\mu=0.06,\sigma=0.2')
ylabel('Pdf')
title('probability density function of normal distribution with \mu=0,06 and \sigma=0.2')
 
%find the pdf of St
subplot(3,1,2)
vol=sigma;
mu_s=S0*exp(mu*t1);
vol_s=S0*exp(mu*t1).*sqrt(exp((vol^2)*t1)-1);
for i=1:length(t1)
    pdf_s(i)=pdf('logn',t1(i),mu_s(i),vol_s(i));
end
hold on
grid on
plot(t1,pdf_s)
title('probability density function of {S}_{t}')
xlabel('E[{{S}_{t}}]={{S}_{0}}{{e}^{\mu t}},var[ {{S}_{t}}]=S_{0}^{2}{{e}^{2\mu t}}( {{e}^{{{\sigma }^{2}}t}}-1)')
ylabel('Pdf')
 
%Find the pdf of xt=log(St)
subplot(3,1,3)
mu_x=log(S0)+(mu-0.5*(vol^2))*t2;
vol_x=vol*sqrt(t2);
 
for i=1:length(t2)
    pdf_x(i)=normpdf(t2(i),mu_x(i),vol_x(i));
end
hold on
grid on
plot(t2,pdf_x)
title('probability density function of log{{S}_{t}}')
xlabel('E[log{{S}_{t}}]=log{{S}_{0}}+(\mu -0.5*{{\sigma }^{2}})t, var[log{{S}_{t}}]={\sigma}^{2}t')
ylabel('Pdf')
