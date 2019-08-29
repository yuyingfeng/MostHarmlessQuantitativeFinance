function std_park = parkinsonHV(HDD,LDD,ODD,N)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
un=log(HDD./ODD);
dn=log(LDD./ODD);
len=length(HDD);
for i=1:(len-N)
std_park(i)=sqrt((1/(4*N*log(2)))*sum((un(i:i+N-1)-dn(i:i+N-1)).^2));
end
std_park=std_park';

end

