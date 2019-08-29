# -*- coding: utf-8 -*-
"""
Created on Tue Aug 13 06:17:09 2019
env: Spyder (Python 3.5)

@author: yuyingfeng 
"""

from scipy import stats
from math import log, sqrt,exp

class qf_option(object):
    def __init__(self, St, K, T, t, r, sigma):
        self.St = float(St)
        self.K  = K
        self.T  = T
        self.t  = t
        self.r  = r
        self.sigma = sigma
        self.d1 = (log(St/K)+(r+0.5*sigma**2)*(T-t))/(sigma*sqrt((T-t)))
        self.d2 = (log(St/K)+(r-0.5*sigma**2)*(T-t))/(sigma*sqrt((T-t)))
    
    def __del__(self):
        class_name =self.__class__.__name__
        #print(class_name, ':delete our qf_option obj')
        
    def gamma(self):
        gamma=stats.norm.pdf(self.d1, 0.0, 1.0)/(self.St*self.sigma*sqrt(self.T-self.t))
        return gamma

    def vega(self):
        vega = self.St * stats.norm.pdf(self.d1, 0.0, 1.0) * sqrt(self.T - self.t)
        #txt book formula is wrong
        return vega

    def prt_option_info(self):
        qf_info=qf_option(self.St, self.K, self.T, self.t, self.r, self.sigma)
        gam=qf_info.gamma()
        veg=qf_info.vega()
        print('When we assume \nSt0=%f K=%f r=%f sigma=%f' %(self.St, self.K, self.r, self.sigma))
        print('The length T\t=%f and the start time t\t=%f' %(self.T,self.t))
        print ('==============The Greek info================')
        print('The Gamma of call option \t=\t %f' % gam)
        print('The Vega of call option \t=\t %f' %veg)

class call_option(qf_option):
    def __int__(self):
        super(call_option,self).__init__()
        print('i am in call option call')
    
    def __del__(self):
        class_name =self.__class__.__name__
        #print(class_name, ':delete our qf_option obj')
    
    def myd1val(self):
        call_price=call_option(self.St, self.K, self.T, self.t, self.r, self.sigma)
        #veg=option_price.vega()
        print('myval is %f=' %call_price.d1)
    
    def val(self):
        val=(self.St*stats.norm.cdf(self.d1, 0.0, 1.0)-self.K*exp(-self.r*(self.T-self.t))*stats.norm.cdf(self.d2, 0.0, 1.0))
        return val

    def delta(self):
        delta=stats.norm.cdf(self.d1, 0.0, 1.0)
        return delta

    def theta(self,gamma):
        theta = -self.r*self.K*exp(-self.r*(self.T-self.t))*stats.norm.cdf(self.d2)-0.5*gamma*(self.St*self.sigma)*(self.St*self.sigma)
        return theta

    def kappa(self):
        kappa= (stats.norm.cdf(-self.d2)-1.00)*exp(-self.r*(self.T-self.t))
        return kappa

    def rho(self):
        rho=self.K*(self.T-self.t)*stats.norm.cdf(self.d2)*exp(-self.r*(self.T-self.t))
        return rho

    def impvol(self, C0, sigma_est= 0.2, N= 1000):
        opts = call_option(self.St, self.K, self.T, self.t, self.r, sigma_est)
        for i in range(N):
            opts.sigma =opts.sigma-(opts.val()-C0)/opts.vega()
        return opts.sigma
    
    def prt_option_info(self):
        call_price=call_option(self.St, self.K, self.T, self.t, self.r, self.sigma)
        value=call_price.val()
        veg=call_price.vega()
        delt=call_price.delta()
        gam=call_price.gamma()
        thet=call_price.theta(gam)
        kapp=call_price.kappa()
        rh=call_price.rho()
        iv=call_price.impvol(C0=value)
        print('When we assume \nSt=%f K=%f r=%f sigma=%f' %(self.St, self.K, self.r, self.sigma))
        print('The length T\t=%f and the start time t\t=%f' %(self.T,self.t))
        print('The price of call option \t=\t %f' %value)
        print ('==============The CALL Greek info================')
        print('The Delta of call option \t=\t %f' % delt)
        print('The Gamma of call option \t=\t %f' % gam)
        print('The Theta of call option \t=\t %f' % thet)
        print('The Kappa of call option \t=\t %f' % kapp)
        print('The Rho of call option \t\t=\t %f' % rh)
        print('The Vega of call option \t=\t %f' %veg)
        print('The implied volatility \t\t=\t %f' %iv)

class put_option(call_option):
    def __int__(self):
        super(put_option,self).__init__()
        #print('i am in put option call')
    
    def __del__(self):
        class_name =self.__class__.__name__
        #print(class_name, ':delete our qf_option obj')
    
    def val(self):
        call_val = call_option(self.St, self.K, self.T, self.t, self.r, self.sigma)
        val = self.K*exp(-self.r*(self.T-self.t))-self.St+call_val.val()
        return val
    
    def delta(self):
         delta=stats.norm.cdf(self.d1, 0.0, 1.0)-1
         return delta
    
    def theta(self,gamma):
        theta = -self.r*self.K*exp(-self.r*(self.T-self.t))*stats.norm.cdf(-self.d2)-0.5*gamma*(self.St*self.sigma)*(self.St*self.sigma)
        return theta

    def kappa(self):
        kappa= (stats.norm.cdf(-self.d2))*exp(-self.r*(self.T-self.t))
        return kappa

    def rho(self):
        rho=-self.K*(self.T-self.t)*stats.norm.cdf(-self.d2)*exp(-self.r*(self.T-self.t))
        return rho

    def impvol(self, C0, sigma_est= 0.2, N= 1000):
        opts = put_option(self.St, self.K, self.T, self.t, self.r, sigma_est)
        for i in range(N):
            opts.sigma =opts.sigma-(opts.val()-C0)/opts.vega()
        return opts.sigma
    
    def prt_option_info(self):
        put_price=put_option(self.St, self.K, self.T, self.t, self.r, self.sigma)
        value=put_price.val()
        veg=put_price.vega()
        delt=put_price.delta()
        gam=put_price.gamma()
        thet=put_price.theta(gam)
        kapp=put_price.kappa()
        rh=put_price.rho()
        iv=put_price.impvol(C0=value)
        print('When we assume \nSt=%f K=%f r=%f sigma=%f' %(self.St, self.K, self.r, self.sigma))
        print('The length T\t=%f and the start time t\t=%f' %(self.T,self.t))
        print('The price of put option \t=\t %f' %value)
        print ('==============The PUT Greek info================')
        print('The Delta of put option \t=\t %f' % delt)
        print('The Gamma of put option \t=\t %f' % gam)
        print('The Theta of put option \t=\t %f' % thet)
        print('The Kappa of put option \t=\t %f' % kapp)
        print('The Rho of put option \t\t=\t %f' % rh)
        print('The Vega of put option \t\t=\t %f' %veg)
        print('The implied volatility \t\t=\t %f' %iv)


class riskreversal(call_option):
    'calculate risk reversl option'
    def __init__(self, St, K, T, t, r, sigma,K2):
        call_option.__init__(self,St, K, T, t, r, sigma)
        self.K2 =K2
        #print(self.K2)
        #print(self.d1)
        #print(self.val())
        
    def __del__(self):
        class_name =self.__class__.__name__
        #print(class_name, ':delete our qf_option obj')
    
    def put_val(self):
        call_val = call_option(self.St, self.K2, self.T, self.t, self.r, self.sigma)
        val = self.K2*exp(-self.r*(self.T-self.t))-self.St+call_val.val()
        #print(call_val.val())
        return val
    
    def val(self):
        call_val = call_option(self.St, self.K, self.T, self.t, self.r, self.sigma)
        tmp = call_option(self.St, self.K2, self.T, self.t, self.r, self.sigma).val()
        put_val = self.K2*exp(-self.r*(self.T-self.t))-self.St+tmp
        val =call_val.val()-put_val
        #print('what is rr val=',val)
        return val
    
    def prt_option_info(self):
        rr_price=riskreversal(self.St, self.K, self.T, self.t, self.r, self.sigma,self.K2)
        value=rr_price.val()
        print('When we assume \nSt=%f K1=%f K2=%f r=%f sigma=%f' %(self.St, self.K, self.K2, self.r, self.sigma))
        print('The length T\t=%f and the start time t\t=%f' %(self.T,self.t))
        print('The price of rr option \t=\t %f' %value)
        print ('==============The RR Greek info=====NOt done yet=====')

            
def riskreversal_val(St,K1,K2,T,t,r,sigma):
    '''please compare to the class version of riskreversal_val'''
    call_val = call_option(St, K1, T, t, r, sigma)
    put_val  = put_option(St, K2, T, t, r, sigma)
    val = call_val.val()-put_val.val()
    return val

def main():
    St=100.00   #the price of underlying asset
    K=90.00    #the strike price
    T=1.0       #the length of call option contract
    t=0.1       #the initial time
    r=0.05      #risk-free rate
    sigma=0.20  #the volatility
    
    #test qf_option class
    option_price=qf_option(St, K, T, t, r, sigma)
    option_price.prt_option_info()
    
    gamma =option_price.gamma()
    print('my option call gamma=',gamma)
    
    print('***************') 
    
    St=102.00   #the price of underlying asset
    K=115.00    #the strike price
    T=1.2       #the length of call option contract
    t=0.0       #the initial time
    r=0.06      #risk-free rate
    sigma=0.20  #the volatility
    
    #test call_option class
    call_price = call_option(St, K, T, t, r, sigma)
    call_price.prt_option_info()
    
    #test put_option class
    put_price = put_option(St, K, T, t, r, sigma)
    put_price.prt_option_info()
    
    #test rr_option class
    K2=100
    rr_class =riskreversal(St, K, T, t, r, sigma,K2)
    #rr_class.val()
    rr_class.prt_option_info()
    #    
    rskrev_price=riskreversal_val(St,K, K2,T, t, r, sigma)
    print('riskrev_price = ',rskrev_price)

if __name__ == "__main__":
    main()



