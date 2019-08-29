clear
syms x y t mu1 mu2 sig1 sig2 F a b 
syms dF dt dw1 dw2 
F=x*y
%F=x/y
 
JF=jacobian(F)
HF=hessian(F)
F_t=diff(F,t)
 
a=[mu1*x; mu2*y];
%b=[sig1*x,0;0 sig2*y];%two indp random source case
b=[sig1*x, 0; sig2*y, 0]; %single random source case
 
dW=[dw1; dw2];
 
%dF=(F_t+JF*a+0.5*trace((b.’)*HF*b))*dt+JF*b*dW
dF=simplify((F_t+JF*a+0.5*trace((b.')*HF*b))*dt+JF*b*dW)
