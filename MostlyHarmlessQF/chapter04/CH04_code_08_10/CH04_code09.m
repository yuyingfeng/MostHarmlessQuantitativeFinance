clear
close all
S=[0:0.01:10]; %underlying asset prices
K=5;%strike price
B=2;
typ='c';
pay_off_c= european_opt_payoff(typ,S, K);
 
typ='p';
pay_off_p= european_opt_payoff(typ,S, K);
 
xmin=min(S);
xmax=max(S);
ymin=min(-pay_off_c);
ymax=max(pay_off_c);
 
subplot(2,2,1)
plot(S,pay_off_c);
ylabel('Long a call payoff')
xlabel('underlying asset price')
axis([xmin,xmax,ymin,ymax]);
 
subplot(2,2,2)
plot(S,pay_off_p);
axis([xmin,xmax,ymin,ymax]);
ylabel('Long a put payoff')
xlabel('underlying asset price')
 
subplot(2,2,3)
plot(S,-pay_off_c);
ylabel('Short a call payoff')
xlabel('underlying asset price')
axis([xmin,xmax,ymin,ymax]);
subplot(2,2,4)
plot(S,-pay_off_p);
axis([xmin,xmax,ymin,ymax]);
ylabel('Short a put payoff')
xlabel('underlying asset price')

