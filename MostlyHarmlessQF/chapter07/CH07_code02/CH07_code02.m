clear 
close
mu1=[2;10];
 
n1=1800
g1=1.2*randn(2,n1)+repmat(mu1,[1,n1]);
plot(g1(1,:),g1(2,:),'.')
 
n2=1500;
g2=repmat([0.8;1.5],[1,n2]).*randn(2,n2);
hold on
grid on
plot(g2(1,:),g2(2,:),'.')
plot(linspace(-3,6,n2),6*ones(n2,1),'LineWidth',2)
