clear 
price=50;
K=50;
M=100;
T=1;
N=400;
r=0.06;
vol=0.2;
v=r-0.5*vol^2;
dt=T/N;
dx=vol*sqrt(3*dt);
pu=(dt*vol^2)/(2*(dx^2))+v*dt/(2*dx);
pm=1.0-(dt*(vol^2))/(dx^2);
pd=(dt*(vol^2))/(2*dx^2)-v*dt/(2*dx);
%initial stock price matrix and option price matrix
S=zeros(N+1,2*M+1);
C=zeros(N+1,2*M+1);
 
%payoff at terminal time 
for m=1:(2*M+1)
    jj=m-M-1;
    S(N+1,m)=price*exp(jj*dx);
    C(N+1,m)=max(S(N+1,m)-K,0);
end
     
for i=N:-1:1
    %initialize boundary conditions
    C(i,1)=0.0;
    %C(i,1)=C(i,2);%alternative setting
    C(i,2*M+1)=max(S(N,2*M+1)-K,0);

    for j=(2*M):-1:2
       C(i,j)=(exp(-r*dt))*(pu*C(i+1,j+1)+pm*C(i+1,j)+pd*C(i+1,j-1));
    end
end  

%perparing graph
y=[0:1/N:T];%Time
x=[1:2*M+1];% state prices 
x=(max(S(N+1,:))-min(S(N+1,:)))/(2*M+1)*x;
[XX,YY]=meshgrid(x,y);
figure
mesh(XX,YY,C)
 
ylabel('T')
xlabel('Underlying Prices')
 
display(['European Call Option Price=',num2str(C(1,M+1))])
