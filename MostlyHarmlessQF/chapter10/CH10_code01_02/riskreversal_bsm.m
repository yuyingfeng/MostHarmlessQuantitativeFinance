function C_riskreversal_bsm = riskreversal_bsm(ST,r,T,vol,q,K1,K2)

C2_bsm=blsprice(ST*exp(-r*T),K2,r,T,vol,q);
[dum,P1_bsm]=blsprice(ST*exp(-r*T),K1,r,T,vol,q);
C_riskreversal_bsm=C2_bsm-P1_bsm;

end

