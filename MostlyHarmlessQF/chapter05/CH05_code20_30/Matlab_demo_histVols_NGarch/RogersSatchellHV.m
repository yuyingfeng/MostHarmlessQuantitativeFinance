function std_rs  = RogersSatchellHV( HDD,LDD,ODD,CDD,N)
%Calculate RogerSatchell historical volatilities
% written by Yingfeng Yu
% --need more clarifictions

un=log(HDD./ODD);
dn=log(LDD./ODD);
cn=log(CDD./ODD);
len=length(HDD);
    for i=1:(len-N)
        tmp=un(i:i+N-1).*(un(i:i+N-1)-cn(i:i+N-1))+dn(i:i+N-1).*(dn(i:i+N-1)-cn(i:i+N-1));
        std_rs(i)=sqrt(mean(tmp));
    end
    std_rs=std_rs';

end

