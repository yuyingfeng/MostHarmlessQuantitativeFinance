%test_longacall_payoff.m
clear
close
 
T=0; %Expiration
K=50; % Strike price
r=0.1; %Risk-free rate
Sigma =0.40; %Volatility
q=0; %Dividend rate
 
S=40:60;
figure
[C,P]=blsprice(S,K,r,T,Sigma,q);
%blsprice is a bulit-in matlab function
plot(S,C);
xlabel('Underlying asset prices')
ylabel('Call option payoffs')
