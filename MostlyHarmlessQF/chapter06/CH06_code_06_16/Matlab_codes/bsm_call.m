function call_price = bsm_call(S,K,T,t,r,b,vol) 
%written by Yuyingfeng
d1=(log(S/K)+(b+(vol^2)/2)*(T-t))/(vol*sqrt(T-t));
d2=d1-vol*sqrt(T-t);
call_price =S*exp((b-r)*(T-t))*normcdf(d1,0,1)-K*exp(-r*(T-t))*normcdf(d2,0,1);
end

