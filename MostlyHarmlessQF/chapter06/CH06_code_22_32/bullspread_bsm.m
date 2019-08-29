function C_bullspread_bsm= bullspread_bsm(ST,r,T,vol,q,K1,K2)
%using Matlab built-in function blsprice.m
C1_bsm=blsprice(ST*exp(-r*T),K1,r,T,vol,q);
C2_bsm=blsprice(ST*exp(-r*T),K2,r,T,vol,q);
C_bullspread_bsm=C1_bsm-C2_bsm;
end

