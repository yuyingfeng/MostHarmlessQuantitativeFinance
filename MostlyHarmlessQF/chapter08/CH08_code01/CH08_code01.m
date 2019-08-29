%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: demonstrate how to use nerlove1963 data to construct OLS 
clear all
load nerlove1963.mat
format long
Y=lntc; %explained variable (dependent variable)
N=length(lntc); %Number of obs
K=5; %Number of exploratory variables including constant term
X=[ones(N,1),lnq,lnpl,lnpk,lnpf];%constructing X matrix
%in the first col, we create ones array for computing constant term 
b=(inv(X'*X))*(X')*Y; %OLS estimated parameters
e=Y-X*b; %error 
TSS=(Y-mean(Y))'*(Y-mean(Y)); %Total
SSS=(X*b-mean(Y))'*(X*b-mean(Y)); %Model
RSS=TSS-SSS;%Residual
R_square=SSS/TSS;
AdjR_square=1-((e'*e)/(N-K))/(var(Y-mean(Y)));
 
std_err=sqrt((e'*e)/(N-K));%standard error, s
tmp=inv(X'*X);
for i=1:K
    se(i)=std_err*sqrt(tmp(i,i));
    t_val(i)=b(i)/se(i);
    if t_val(i)>0
    P_val(i)=2*tcdf(-t_val(i),N-K);
    else
        P_val(i)=2*tcdf(t_val(i),N-K);
    end
end
display('|--------------------------Results------------------|')
display('|-Names--------|---Coef---|--Std_err-|----t----|---P>|t|----|')
display(['|lnq-----------|',num2str(b(2)),'   | ',num2str(se(2)),' | ',num2str(t_val(2)),' | ',num2str(P_val(2)),' |',])
display(['|lnpl----------|',num2str(b(3)),'   | ',num2str(se(3)),'   | ',num2str(t_val(3)),'  | ',num2str(P_val(3)),' |',])
display(['|lnpk----------|',num2str(b(4)),'  | ',num2str(se(4)),'  | ',num2str(t_val(4)),' | ',num2str(P_val(4)),' |',])
display(['|lnpf----------|',num2str(b(5)),'   | ',num2str(se(5)),'  | ',num2str(t_val(5)),'  | ',num2str(P_val(5)),' |',])
display(['|_cons---------|',num2str(b(1)),'   | ',num2str(se(1)),'   | ',num2str(t_val(1)),' | ',num2str(P_val(1)),' |',])
 
display('|-------Source-----------------|')
display(['     TSS=',num2str(TSS)])
display(['     SSS=',num2str(SSS)])
display(['     RSS=',num2str(RSS)])
display('|------------------------------|')
display(['     R_square=',num2str(R_square)])
display(['     AdjR_square=',num2str(AdjR_square)])
display(['     Root MSE=',num2str(std_err)])
display('|------------------------------|')
F_val=(N-K)*R_square/((1-R_square)*(K-1));
display(['     Number of obs=',num2str(N)])
display(['     F(',num2str(K-1),',',num2str(N-K),')=',num2str(F_val)])
Aic=log(e'*e/N)+2*K/N;
Bic=log(e'*e/N)+log(N)*(K/N);
HQic=log(e'*e/N)+log(log(N))*(K/N);
display('|----AIC----|----BIC----|----HQIC----|')
display(['|  ',num2str(Aic),'  |  ',num2str(Bic),'  |  ',num2str(HQic),'   |'])

vnames=['yvar',
        'cons',
        'lnq ',
        'lnpl',
        'lnpk',
        'lnpf'];


