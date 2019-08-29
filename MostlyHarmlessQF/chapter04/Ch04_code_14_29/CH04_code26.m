clear
close all
S=[0:0.01:15]; %underlying asset prices
%Testing butterfly option
K=10;%strike price
E=4;
if E>K
    display('The butterfly setting is improper.')
    return
else
pay_off_b = butterfly_payoff(S,K,E);
end
 
%Testing condor option
K1=6;%strike price
K2=10;
E=4;
if (E>K1)||(K1>K2)||(E>K2)
    display('The condor setting is improper.')
    return
else
    pay_off_condor = condor_payoff(S,K1,K2,E);
end
 
xmin=min(S);
xmax=max(S);
ymin=min(pay_off_b);
ymax=max(1.2*pay_off_b);
subplot(2,1,1)
hold on
plot(S,pay_off_b);
grid on
ylabel('Long a butterfly payoff')
xlabel('underlying asset price')
axis([xmin,xmax,ymin,ymax]);
 
subplot(2,1,2)
hold on
ymax=max(1.2*E);
plot(S,pay_off_condor );
grid on
ylabel('Long a condor payoff')
xlabel('underlying asset price')
axis([xmin,xmax,ymin,ymax]);
