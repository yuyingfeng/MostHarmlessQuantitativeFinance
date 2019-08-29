clear
close

T=0.0;        %  Expiration
K=50;         %  Strike price
r=0.1;        %  Risk-free rate
Sigma =0.4;   %  Volatility
q=0;          %  Divide Rate

S0=1:60;      %  Underlying Asset Prices
figure
for T=2:-0.5:0
  [C,P]=blsprice(S0,K,r,T,Sigma,q);
  hold on
  plot(S0,C);
end
xlabel('Underlying Asset Prices')
ylabel('Call Option Payoffs')
