clear
close all
S=[0:0.01:10]; %underlying asset prices
K1=8;%strike price
K2=5;
pay_off = strangle_payoff(S,K1,K2);
 
xmin=min(S);
xmax=max(S);
ymin=min(S);
ymax=max(1.2*pay_off);
hold on
subplot(2,1,1)
plot(S,pay_off);
grid on
ylabel('Long a strangle payoff')
xlabel('underlying asset price')
title('In-the-Money Strangle Option')
axis([xmin,xmax,ymin,ymax]);
 
subplot(2,1,2)
K1=5;%strike price
K2=8;
pay_off = strangle_payoff(S,K1,K2);
plot(S,pay_off);
grid on
ylabel('Long a strangle payoff')
xlabel('underlying asset price')
title('Out-of-Money Strangle Option')
axis([xmin,xmax,ymin,ymax]);
