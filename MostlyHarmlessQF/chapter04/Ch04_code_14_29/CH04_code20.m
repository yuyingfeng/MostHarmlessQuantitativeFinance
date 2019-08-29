clear
close all
S=[0:0.01:10]; %underlying asset prices
K=5;%strike price
pay_off = straddle_payoff(S,K);
 
xmin=min(S);
xmax=max(S);
ymin=min(pay_off);
ymax=max(1.2*pay_off);
hold on
plot(S,pay_off);
grid on
ylabel('Long a straddle payoff')
xlabel('underlying asset price')
axis([xmin,xmax,ymin,ymax]);
