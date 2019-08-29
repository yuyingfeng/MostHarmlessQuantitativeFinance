clear
close all
S=[0:0.01:10]; % underlying asset prices
K=5;%strike price
B=2;
typ='c';
pay_off_c=binary_opt_payoff(typ,S, K, B);
 
typ='p';
pay_off_p=binary_opt_payoff(typ,S, K, B);
 
xmin=min(S);
xmax=max(S);
ymin=min(pay_off_c);
ymax=2*B;
subplot(2,1,1)
plot(S,pay_off_c);
xlabel('binary call')
axis([xmin,xmax,ymin,ymax]);
subplot(2,1,2)
ymin=min(pay_off_p);
plot(S,pay_off_p);
axis([xmin,xmax,ymin,ymax]);
xlabel('binary put')
