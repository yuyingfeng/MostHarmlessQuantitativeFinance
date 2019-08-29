function C_condor_bsm = condor_bsm(ST,r,T,vol,q,K1,K2,E)

C1_bsm=blsprice(ST*exp(-r*T),(K1-E),r,T,vol,q);
C2_bsm=blsprice(ST*exp(-r*T),K1,r,T,vol,q);
C3_bsm=blsprice(ST*exp(-r*T),K2,r,T,vol,q);
C4_bsm=blsprice(ST*exp(-r*T),(K2+E),r,T,vol,q);
C_condor_bsm=C1_bsm-C2_bsm-...
    C3_bsm+C4_bsm;

end

