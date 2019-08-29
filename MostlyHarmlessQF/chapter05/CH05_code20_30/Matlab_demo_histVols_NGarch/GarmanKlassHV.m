function std_gk = GarmanKlassHV(HDD,LDD,ODD,CDD,N)
%written by Yingfeng Yu
%   此处显示详细说明

un=log(HDD./ODD);
dn=log(LDD./ODD);
cn=log(CDD./ODD);

C1=0.511;
C2=0.019;
C3=0.385;

len=length(HDD);
for i=1:(len-N)
    prt1=(C1/N)*sum((un(i:i+N-1)-dn(i:i+N-1)).^2);
    
    pprt1=cn(i:i+N-1).*(un(i:i+N-1)+dn(i:i+N-1));
    pprt2=2*un(i:i+N-1).*dn(i:i+N-1);
    prt2=-(C2/N)*sum(pprt1+pprt2);
    
    prt3=-(C3/N)*sum(cn(i:i+N-1).^2);
    
    std_gk(i)=sqrt(prt1+prt2+prt3);
end
std_gk=std_gk';

end

