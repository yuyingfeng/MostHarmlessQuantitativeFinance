function std_CtC = CtCHV(dd,N)
%Close-to-Close Historical Volatility
%   input: prices, (len+1)*1
%   output: std CtC,len*1
rets=diff(log(dd));
len=length(rets);
for i=1:(len-N)
    std_CtC(i)=std(rets(i:i+N-1));
end
std_CtC=std_CtC';





end

