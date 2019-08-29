function ST = simul_GBM(S0,r,vol,N_sim,N_time,T)
%simulate geometric Browonian Motion
dt=T/N_time;
S(1)=S0;
   for j=1:N_sim
        for i=1:N_time
            z=randn(1,1);
            S(i+1)=S(i)*exp((r-0.5*(vol^2))*dt+...
            vol*sqrt(dt)*z);
        end
        ST(j)=S(end);
   end
   
end
