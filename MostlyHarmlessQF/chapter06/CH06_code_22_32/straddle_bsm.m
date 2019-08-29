function C_straddle_bsm= straddle_bsm(ST,r,T,vol,q,K)

[C1_bsm,P1_bsm]=blsprice(ST*exp(-r*T),K,r,T,vol,q);
C_straddle_bsm=C1_bsm+P1_bsm;

end

