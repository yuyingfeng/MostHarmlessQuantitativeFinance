# -*- coding: utf-8 -*-
"""
Created on Sun Mar 10 18:46:27 2019

@author: yuyin
"""
import numpy as np

def PriceFXForward(S0, Rdc,Rfc,T):
    # Pricing FX forward
    F=S0*(((1+Rdc)/(1+Rfc))**(T/365))
    return F

def ValueFXForward(St, F, Rdc,Rfc,T,t ):
    # valuation of Vt(F0:T)
    Val=St/((1+Rfc)**((T-t)/365))-F/((1+Rdc)**((T-t)/365))
    return Val

#main function
Rdc=1/100
Rfc=3/100
T=365
S0=1.0625
#Pricing FX forward 

F= PriceFXForward(S0, Rdc,Rfc,T)
#After 180 days, valuing Vt(F0:T)
t=180
St=1.1
Val= ValueFXForward(St, F, Rdc,Rfc,T,t)
print('What is the price of FX forward = ',F)
print("What is the Value of FX forward after %d = " %(t),Val)
