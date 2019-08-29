function [P_ST,N_ST] = simul_GBM_antithetic_sampling(S0,r,vol,N_sim,N_time,T)
% simulate geometric Browonian Motion
% using antithetic sampling method
dt=T/N_time;
P_S(1)=S0;
N_S(1)=S0;
   for j=1:N_sim
        for i=1:N_time
            z=randn(1,1);
            P_S(i+1)=P_S(i)*exp((r-0.5*(vol^2))*dt+...
            vol*sqrt(dt)*z);% positive part
            N_S(i+1)=N_S(i)*exp((r-0.5*(vol^2))*dt-...
            vol*sqrt(dt)*z);% negative part
        end
        P_ST(j)=P_S(end);
        N_ST(j)=N_S(end);
   end
end
