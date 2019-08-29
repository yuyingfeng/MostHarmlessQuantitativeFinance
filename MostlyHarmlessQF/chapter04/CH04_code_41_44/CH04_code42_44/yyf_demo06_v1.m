%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Lecturer :Marcus, Yingfeng, Yu
%  Copyright (c) 2014, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@live.com

close all
clear all

load sp500_ibm_apple_90_14Apr03.mat

%from left 2 right-->from old days to today
SP500=flipud(sp500_900101_140403);%
%APP=flipud(apple_900101_140403);
%IBM=flipud(ibm_900101_140403);
date_info=SP500(:,1);

R_SP500=diff(log(SP500(:,2)));
R_date_info=SP500(2:end,1);

pp=1%
nn=250
%to calculate 1 day, alph=1-pp=1%, @Jan-03-2011 VaR

%step 1 peprapre 250 trading days returns

if length(5045:5294)==nn%to make sure 250 trading days
R_tmp=R_SP500(5045:5294);
%check
datestr(R_date_info(5045))
datestr(R_date_info(5294))
else 
    break;
end

R_tmp_dinfo=R_date_info(5045:5294);

%step 2: sort these 250-trading-day returns
vv=sort(R_tmp);
 indx=nn*pp/100;
 if rem(indx,1)==0
     R_VaR2=-(vv(indx)+vv(indx+1))/2
%    % b=vv(indx)
 else
%     %algorithm 1
    indx=ceil(indx);
     R_VaR2=-vv(indx)%matlab uses this algorithm
%     %alogorithm 2 %linear interpolation 
%      %indx1=ceil(indx+1);
%     %indx2=floor(indx+1);
%     %R_VaR=vv(indx2)+rem(indx,1)*(vv(indx1)-vv(indx2))
 end
%or simply use 
ddd=10;%ten days
R_VaR=-prctile(R_tmp,pp);
R_VaR_10d=sqrt(ddd)*R_VaR;
dollar_VaR=1-exp(-R_VaR_10d);

display('|--------------Demonstrating the results-----------|')
display(['|name--------|----Results----|--p=',num2str(100-pp),'--d=',num2str(ddd),'--|'])
display(['|1 day R_VaR-|',num2str(R_VaR),'-------|'])
display(['|10-day R_VaR|',num2str(R_VaR_10d),'--------|'])
display(['|10-day$VaR--|',num2str(dollar_VaR),'--------|'])



