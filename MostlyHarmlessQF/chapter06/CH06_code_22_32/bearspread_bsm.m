function C_bearspread_bsm= bearspread_bsm(ST,r,T,vol,q,K1,K2)

[dum1,P1_bsm]=blsprice(ST*exp(-r*T),K2,r,T,vol,q);
[dum2,P2_bsm]=blsprice(ST*exp(-r*T),K1,r,T,vol,q);
C_bearspread_bsm=P1_bsm-P2_bsm;
end

