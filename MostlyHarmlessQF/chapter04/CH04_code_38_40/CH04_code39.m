R1=0.1;
R2=0.2;
Sig1=0.04;
Sig2=0.06;
r=0.8;
w1=[0:0.001:1];
w2=1-w1;
Rp=w1*R1+w2*R2;
Sigp=sqrt(w1.^2.*Sig1.^2+w2.^2.*Sig2.^2+2*r*w1.*w2.*Sig1.*Sig2);

grid on
stem3(Sigp,Rp,w1)
xlabel('risk')
ylabel('return')
zlabel('w1')
