function C_butterfly_bsm = butterfly_bsm(ST,r,T,vol,q,K,E)

C1_bsm=blsprice(ST*exp(-r*T),(K-E),r,T,vol,q);
C2_bsm=blsprice(ST*exp(-r*T),K,r,T,vol,q);
C3_bsm=blsprice(ST*exp(-r*T),K+E,r,T,vol,q);
C_butterfly_bsm=C1_bsm-2*C2_bsm+C3_bsm;

end

