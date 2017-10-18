# File created to test the SymbolSynchronizer class, implemented to
# this project to be an alternative to package comm.SymbolSynchronizer
# from Matlab

clear all; close all; clc;

N = 1000;
sps = 40;
SNR = 100;

Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;

h = squarerootrcosfilter(0.25, 20, sps);         #Raised Cosine FIR Filter design
plot(h)
bits = randi([0 1], 1, N);                      #Random Data
tx_signal = 2*bits - 1;                         #BPSK Modulation

%h = ones(1,sps);
%up = upsample (tx_signal, sps);
%s = conv(Hs, up);
%x = s(1:N*sps);

x = upfirdn(tx_signal, h, sps, 1);              #Raised Cosine Tx Filter 
r = awgn(x, SNR, 'measured');                 #Add Noise

%Hr = fliplr(Hs); %Inverte o sinal da esquerda para a direita
%y = (conv(r, Hr)) / sps; %filtro casado;
%y = y(1:N*sps);

y = upfirdn(r, h, 1, 1);                    #Raised Cosine Rx Filter
y = y(1:N*sps);

                                                #Symbol Synchronizer
instants3 = early_late_nda(y, sps, 3, 1, 0.5);
figure(2)
plot(t, y); xlim([0 1000]); grid on;
hold on;
plot(t(instants3), y(instants3), 'ro'); xlim([0 1000]);

    
# [EOF]    