# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 17:04:22 2019

@author: 
"""

import numpy as np

def PriceFXForward(S0, Rdc,Rfc,T):
    # Pricing FX forward
    F=S0*(((1+Rdc)/(1+Rfc))**(T/365))
    return F

def CoveredIntArbitrage(S0,Fmkt,Rdc,Rfc,T):
# input: S0, spot rate
#           Fmkt, FX forward market price
#           Rdc, Domestic interest rate
#           Rfc, Foreign interest rate
#           T, the maturity of FX forward
#output: prof, profit investor earned
#            initial_currency: Initially, the currency investor should
#            lend from bank
    F=PriceFXForward(S0, Rdc,Rfc,T);
    if (F<Fmkt):
        prof =1000*((Fmkt/S0)*(1+Rfc)**(T/365)-(1+Rdc)**(T/365))
        initial_currency='DC'
    else:
        prof =1000*((S0/Fmkt)*(1+Rdc)**(T/365)-(1+Rfc)**(T/365))
        initial_currency='FC'

    return prof, initial_currency

Rdc=1/100;
Rfc=3/100;
T=365;
S0=1.0625;
Fmkt=1.0800;
 
prof,initial_currency=CoveredIntArbitrage(S0,Fmkt,Rdc,Rfc,T)

print('We earn profit=',prof,initial_currency)
