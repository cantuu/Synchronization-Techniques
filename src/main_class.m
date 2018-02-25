# File created to test the SymbolSynchronizer class, implemented to
# this project to be an alternative to package comm.SymbolSynchronizer
# from Matlab

clear all; close all; clc;

N = 50000;
sps = 40;
SNR = 100;

Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;

span = 20;
rolloff = 0.25;

h = squarerootrcosfilter(rolloff, span, sps);   #Raised Cosine FIR Filter design
bits = randi([0 1], 1, N);                      #Random Data
tx_signal = 2*bits - 1;                         #BPSK Modulation

x = upfirdn(tx_signal, h, sps, 1);              #Raised Cosine Tx Filter 
r = awgn(x, SNR, 'measured');                   #Add Noise

r = [0 0 0 0 r];

y = upfirdn(r, h, 1, 1);                        #Raised Cosine Rx Filter
y = y(1:N*sps);
                                                #Symbol Synchronizer
comm = SymbolSynchronizer('SamplesPerSymbol', sps, 'NormalizedLoopBandwidth', 0.005); #Zero-Crossing
comm1 = SymbolSynchronizer('TimingErrorDetector', 'Mueller & Muller', 'SamplesPerSymbol', sps); #Mueller & Muller
comm2 = SymbolSynchronizer('TimingErrorDetector', 'Gardner', 'SamplesPerSymbol', sps, 'NormalizedLoopBandwidth', 0.01); #Gardner
comm3 = SymbolSynchronizer('TimingErrorDetector', 'Early-Late', 'SamplesPerSymbol', sps*1.001); #Early-late

instants = step(comm, y);
instants1 = step(comm1, y);              
instants2 = step(comm2, y);              
instants3 = step(comm3, y);              
              

subplot(221)
plot(t, y); #xlim([0 1000]); grid on;
hold on; plot(t(instants), y(instants), 'ro'); #xlim([0 1000]);
title('Zero-Crossing')

subplot(222)
plot(t, y); #xlim([0 1000]); grid on;
hold on; plot(t(instants1), y(instants1), 'ro'); #xlim([0 1000]);
title('Mueller & Muller')

subplot(223)
plot(t, y); #xlim([0 1000]); grid on;
hold on; plot(t(instants2), y(instants2), 'ro'); #xlim([0 1000]);
title('Gardner')

subplot(224)
plot(t, y); #xlim([0 1000]); grid on;
hold on; plot(t(instants3), y(instants3), 'ro'); #xlim([0 1000]);
title('Early-Late')

%reset(comm);
%
%comm = SymbolSynchronizer('TimingErrorDetector', 'Mueller & Muller', 'SamplesPerSymbol', sps); #Mueller & Muller
%instants3 = step(comm, y);              
%
%figure(2)
%plot(t, y); xlim([0 1000]); grid on;
%hold on;
%plot(t(instants3), y(instants3), 'ro'); xlim([0 1000]);
    
% Exemplo de Construtor
% a = SymbolSynchronizer('TimingErrorDetector', 'Early-Late', 'SamplesPerSymbol', ...
%     5, 'DampingFactor', 0.5, 'NormalizedLoopBandwidth', 0.005, 'DetectorGain', 2)    
    
# [EOF]    
