# File created to test the SymbolSynchronizer class, implemented to
# this project to be an alternative to package comm.SymbolSynchronizer
# from Matlab

clear all; close all; clc;

N = 1000;
sps = 2;
Eb_N0 = 10;

Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;
Ht = ones(1, sps);

bits = randi([0 1], 1, N);            #Random Data
tx_signal = 2*bits - 1;               #BPSK Modulation

# Same than upsample...
sig_zerostuff = zeros(1, (length(bits)*sps)-1);
sig_zerostuff(1:sps:length(sig_zerostuff)) = tx_signal;
ipl_signal = conv(sig_zerostuff, Ht);

# Tx Filter
# Insert Noise
    # Scatterplot
# Rx Filter
# Symbol Synchronizer
    # Scatterplot
    
# [EOF]    