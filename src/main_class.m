# File created to test the SymbolSynchronizer class, implemented to
# this project to be an alternative to package comm.SymbolSynchronizer
# from Matlab

clear all; close all; clc;

N = 1000;
sps = 7;
SNR = 100;

Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;

spam = 20;
rolloff = 0.25;

h = squarerootrcosfilter(rolloff, spam, sps);   #Raised Cosine FIR Filter design
bits = randi([0 1], 1, N);                      #Random Data
tx_signal = 2*bits - 1;                         #BPSK Modulation

x = upfirdn(tx_signal, h, sps, 1);              #Raised Cosine Tx Filter 
r = awgn(x, SNR, 'measured');                   #Add Noise

y = upfirdn(r, h, 1, 1);                        #Raised Cosine Rx Filter
y = y(1:N*sps);

                                                #Symbol Synchronizer
comm = SymbolSynchronizer('TimingErrorDetector', 'Gardner', 'SamplesPerSymbol', sps);
instants3 = step(comm, y);              


plot(t, y); xlim([0 1000]); grid on;
hold on;
plot(t(instants3), y(instants3), 'ro'); xlim([0 1000]);
    
% Exemplo de Construtor
% a = SymbolSynchronizer('TimingErrorDetector', 'Early-Late', 'SamplesPerSymbol', ...
%     5, 'DampingFactor', 0.5, 'NormalizedLoopBandwidth', 0.005, 'DetectorGain', 2)    
    
# [EOF]    