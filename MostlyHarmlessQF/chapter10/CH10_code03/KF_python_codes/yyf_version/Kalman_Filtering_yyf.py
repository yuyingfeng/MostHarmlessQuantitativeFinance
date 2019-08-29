
#==========================================================================
#   Kalman Filter                                                                  
#   This Function Implement the Kalman filter for the state space model:
#                        s = Phi*s(-1) + Ga*e            e~N(0,QQ)
#                        y = A + CC*s + GG*t + w         w~N(0,RR)
#  In the above system, y is an (ny*1) vector of observable variables and 
#  s is an ns*1 vector of latent variables. 
#
#  The Input of this function are the state space matrices and a ny*T vector 
#  of observations for y.  
#  
#  The Output is:
#   - measurepredi = the one step ahead prediction for y;
#   - liki = is a 1*T vector containing p(yt|Y1:t-1). The first entry is based  
#            on the prediction of the state vector at its unconditional
#            mean;
#   - statepredi = It is the prediction E[st|Y^(t)];
#   - varstatepredi = It is the MSE of the above prediction;
#  
#  Written by 2016 Yingfeng Yu < yuyingfeng (at) cueb.edu.cn >
#  Capital University of Economics and Business(CUEB),Beijing, China
#  School of Finance, Dept. of International Finance
#  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
##############################################################################
#==========================================================================

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

N=1000;
#step 1: generate an AR(2) process data
delta=0.1;


phi1=0.68
phi2=0.20
sigma=0.01
delta_ar2 =delta/(1-phi1-phi2)

y_ng1=0 #%yt when t=-1
y_ng2=0 #%yt when t=-2;

y =np.zeros((1,N))

if 1==2: # if you want to simulate new y data
    for i in range(N):
        if (i==0):
            y[:,i]=delta+phi1*y_ng1+phi2*y_ng2+sigma*np.random.normal()
        elif (i==1):
            y[:,i]=delta+phi1*y[:,i-1]+phi2*y_ng2+sigma*np.random.normal()
        else:
            y[:,i]=delta+phi1*y[:,i-1]+phi2*y[:,i-2]+sigma*np.random.normal()

    plt.figure()
    plt.plot(y[0,:],'ko',ms=1)
    plt.legend(['Noisy Datapoints'])
    plt.xlabel('Time')
    plt.show()

#try to use h5py it seems it would not work
if 1==10:
    import h5py
    f = h5py.File('yyfQFdata/y.mat','r')
    datta = f.get('y')
    dattaa = np.array(datta)
    print(datta[:5])

#now I suggest you use this routine,
#this is the right way
if 1==1:
    import scipy.io
    mat = scipy.io.loadmat('yyfQFdata/y.mat')
    aa= mat['y']
    print(type(aa))
    print('aa shape =',np.shape(aa))
    y=aa

#try to create pd and save as csv
df = pd.DataFrame(y.T)
df.columns =['y']
#simul_y.to_csv("yyfQFdataout/y.csv",index_label='date')

#np.savetxt('yyfQFdataout/y.csv',y, delimiter=',')
#np.savetxt('y.csv',y, delimiter=',')

Phi = np.zeros((2,2))
Phi[0,0]=phi1
Phi[0,1]=phi2
Phi[1,0]=1
print(Phi)


T        = np.shape(y)[1]
ny       = np.shape(y)[0]

print('T=',T)
ns       = np.shape(Phi)[0]
s        = np.zeros((ns,T+1))
P        = np.zeros((T+1,ns,ns))

A   = delta_ar2
CC  = np.zeros((ny,ns))
CC[0,0]=1


RR =0.0*np.eye(ny)
QQ =sigma*np.eye(ns)

Ga=np.zeros((ns,ns))
Ga[0,0]=1
print(Ga)

GG=np.zeros((ny,1))

#initialize s0|0 and P1|0
s[:,0]     = np.zeros((ns))
P[0,:,:]   = np.ones((ns,ns))

print(np.shape(Ga))

print(np.shape(s))

sinv=np.linalg.inv(np.eye(ns*ns)-np.kron(Phi,Phi))
tmp_mat=np.dot(Ga,np.dot(QQ,Ga.T))
a = np.dot(sinv,np.reshape(tmp_mat,(ns*ns,1)))
print(sinv)
print('a=',a)

P[0,:,:]   = np.reshape(a,(ns,ns))
print(P[0,:,:])

sprime             = np.zeros((ns,1))
Pprime             = np.zeros((ns,ns))
errorprediction    = np.zeros((ny,T))
Varerrorprediction = np.zeros((T,ny,ny))
liki               = np.zeros((T))
measurepredi       = np.zeros((ny,T))

ypredic= np.zeros((ny,T))

print('T=',T)

for i in range(T):
    #Updating Step
    sprime = np.resize(np.dot(Phi,s[:,i]),(2,1)) #  s(:,i)=Si|(i-1); sprime=Si|i

    Pprime = Phi@np.squeeze(P[i,:,:])@(Phi.T) + Ga@QQ@(Ga.T)

    yprediction = A + GG*i + CC@sprime

    ypredic[:,i]=yprediction
    v = y[:,i] - yprediction

    F = CC@Pprime@(CC.T)+RR

    KGain = Pprime@(CC.T)@(np.linalg.inv(F))

    snext   = sprime + np.dot(KGain,v)
    #s[:,i+1] = snext
    s[:,i+1] = np.resize(snext,(2,))
    #s=np.append(snext)
    P[i+1,:,:] = Pprime - KGain@CC@Pprime

    errorprediction[:,i] = v
    Varerrorprediction[i,:,:] = F

    tmp_var=(v.T)@(np.linalg.inv(F))@v

    liki[i] = -2*np.log(2*np.pi)-0.5*(np.log(np.linalg.det(F)))-0.5*tmp_var

    measurepredi[:,i] = y[:,i]-v

statepredi = s
varstatepredi = P

plt.figure()


plt.plot(y[0,:],'ko',ms=1)
plt.plot(ypredic[0,:],'-',lw=1)


plt.legend(['Noisy Datapoints','Kalman estimate'])
plt.xlabel('Time')
plt.show()

est_liki = -np.sum(liki)
print('Total liki=',est_liki)

df.insert(1,'ypredic',ypredic.T)
df.insert(2,'measurepredi', measurepredi.T)
df.insert(3,'lilk',liki)
print(df.head())
df.to_csv("yyfQFdataout/y.csv")