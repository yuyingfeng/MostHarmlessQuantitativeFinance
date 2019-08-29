clear
close all
S=[0:0.01:15]; %underlying asset prices
K1=3;%strike price
K2=12;
pay_off = bearspread_payoff(S,K1,K2);
 
xmin=min(S);
xmax=max(S);
ymin=min(pay_off);
ymax=max(S);
hold on
plot(S,pay_off);
grid on
ylabel('Long a bullspread payoff')
xlabel('underlying asset price')
axis([xmin,xmax,ymin,ymax]);
