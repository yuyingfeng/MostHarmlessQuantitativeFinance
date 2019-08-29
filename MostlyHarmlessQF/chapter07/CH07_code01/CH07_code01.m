clear
close
 
a=1.0;
k=1.8;
x=0.5:0.1:10;
 
epi=1.5*randn(1,length(x));
y=a+k*x+epi;
 
plot(x,y,'.','MarkerSize',10)
 
hold on
%matlab built-in function ols
%ols Linear regression estimation with homoskedasticity 
%        and White heteroskedasticity robust standard errors
[b, tstat, s2, vcv, vcvwhite, R2, Rbar, yhat] = ols(y',x');
 
y_1st=b(1)+b(2)*x;
plot(x,y_1st,'-r')
 
DD=10;
pp=polyfit(x,y,DD);
y_fit=0;
for i=1:(DD+1)
y_fit=y_fit+pp(i)*(x.^(DD-i+1));
end
plot(x,y_fit,'-.k')
 
DD=15;
pp=polyfit(x,y,DD);
y_fit=0;
for i=1:(DD+1)
y_fit=y_fit+pp(i)*(x.^(DD-i+1));
end
plot(x,y_fit,'.-k')
 
 
DD=25;
pp=polyfit(x,y,DD);
y_fit=0;
for i=1:(DD+1)
y_fit=y_fit+pp(i)*(x.^(DD-i+1));
end
plot(x,y_fit,'b')
 
legend('data','1st ord','10th ord','15th ord','25th ord')
