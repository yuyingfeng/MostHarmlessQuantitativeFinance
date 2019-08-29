# -*- coding: utf-8 -*-
"""
Created on Tue Aug 13 16:40:07 2019

@author: yuyin
"""
from mhqf_options import *

def main():
    S0=100.00   #the price of underlying asset
    K=105.00    #the strike price
    T=1.0       #the length of call option contract
    t=0.1       #the initial time
    r=0.05      #risk-free rate
    sigma=0.20  #the volatility
    option_price=qf_option(S0, K, T, t, r, sigma)
    option_price.prt_option_info()
    
    call_price=call_option(S0, K, T, t, r, sigma)
    call_price.prt_option_info()
    
    put_price=put_option(S0, K, T, t, r, sigma)
    put_price.prt_option_info()
    
    K2=100
    rr_class =riskreversal(S0, K, T, t, r, sigma,K2)

    rr_class.prt_option_info()
    #    
    rskrev_price=riskreversal_val(S0,K, K2,T, t, r, sigma)
    print('riskrev_price = ',rskrev_price)
    

if __name__ == "__main__":
    main()