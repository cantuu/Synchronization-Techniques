# File created to test the SymbolSynchronizer class, implemented to
# this project to be an alternative to package comm.SymbolSynchronizer
# from Matlab

clear all; close all; clc;

N = 1000;
sps = 5;
Eb_N0 = 100;

Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;

h = squarerootrcosfilter(0.25, 6, sps);         #Raised Cosine FIR Filter design
bits = randi([0 1], 1, N);                      #Random Data
tx_signal = 2*bits - 1;                         #BPSK Modulation

x = upfirdn(tx_signal, h, sps, 1);              #Raised Cosine Tx Filter 
r = awgn(x, Eb_N0, 'measured');                 #Add Noise
y = upfirdn(r, h, sps, sps);                    #Raised Cosine Rx Filter
y = y(1:N*sps);

                                                #Symbol Synchronizer
instants3 = mueller_and_mueller(y, sps, 1, 0.5);
plot(t, y); xlim([0 1000]); grid on;
hold on;
plot(t(instants3), y(instants3), 'ro'); xlim([0 1000]);
    
# [EOF]    