function C_strangle_bsm= strangle_bsm(ST,r,T,vol,q,K1,K2)

C2_bsm=blsprice(ST*exp(-r*T),K2,r,T,vol,q);
[dum,P1_bsm]=blsprice(ST*exp(-r*T),K1,r,T,vol,q);
C_strangle_bsm=C2_bsm+P1_bsm;

end

