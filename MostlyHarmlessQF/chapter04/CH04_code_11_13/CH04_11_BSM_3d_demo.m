%BSM_3d_demo 
clear
close
S0=1:1:70;
T=2:-1/12:0;
K=50;
r=0.1;
Sigma =0.4;
q=0;

for i=1:length(T)
  for j=1:length(S0)
    [C(i,j,:),P]=blsprice(S0(j),K,r,T(i),Sigma,q);
  end
end

subplot(2,1,1)
mesh(S0,T,C)
ylabel('Time')
xlabel('Underlying Asset Prices')
zlabel('Call Option Payoffs')

subplot(2,1,2)
waterfall(S0,T,C)
ylabel('Time')
xlabel('Underlying Asset Prices')
zlabel('Call Option Payoffs')
