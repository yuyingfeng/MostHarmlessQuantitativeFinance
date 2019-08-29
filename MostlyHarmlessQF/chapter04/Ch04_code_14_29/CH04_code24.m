clear
close all
S=[0:0.01:10]; %underlying asset prices
K1=3;%strike price
K2=8;
if K1>=K2
    display('Sorry, it is improper setting');
    return
else
    pay_off = riskreversal_payoff(S,K1,K2);
end
xmin=min(S);
xmax=max(S);
ymin=min(pay_off);
ymax=max(1.2*pay_off);
hold on
plot(S,pay_off);
grid on
ylabel('Long a risk reversal payoff')
xlabel('underlying asset price')
axis([xmin,xmax,ymin,ymax]);
