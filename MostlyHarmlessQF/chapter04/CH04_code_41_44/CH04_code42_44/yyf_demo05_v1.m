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
load R_sp

dd=10;
pp=0.99;
mm=mean(R_sp);
stdd=std(R_sp);

dd_mm=dd*mean(R_sp);
dd_stdd=sqrt(dd)*std(R_sp);

R_VaR=-norminv(1-pp)*dd_stdd-dd_mm;
dollar_VaR=1-exp(-R_VaR);

display('|--------------Demonstrating the results-----------|')
display(['|name---|----Results----|--p=',num2str(pp),'--d=',num2str(dd),'--|'])
display(['|R_VaR--|',num2str(R_VaR),'-------|'])
display(['|$VaR---|',num2str(dollar_VaR),'-------|'])


