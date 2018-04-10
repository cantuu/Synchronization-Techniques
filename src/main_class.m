# File created to test the SymbolSynchronizer class, implemented to
# this project to be an alternative to package comm.SymbolSynchronizer
# from Matlab

clear all; close all; clc;

N = 4000;
tx = 2*randi([0,1], 1, N) - 1;

sps = 10;
rolloff = 0.5;
l = 50;
%offset = 1;
offset = 0;

h = srrc(l, rolloff, sps, offset);
r = upfirdn(tx, h, sps, 1);

r = awgn(r, 100, 'measured');
r = [zeros(1,3) r];

matched = srrc(l, rolloff, sps, 0);
y = upfirdn(r, matched, 1, 1);

sps = sps*1.001;

%comm = SymbolSynchronizer('SamplesPerSymbol', sps*1.001, 'NormalizedLoopBandwidth', 0.01, ...
%                          'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Zero-Crossing

%comm = SymbolSynchronizer('TimingErrorDetector', 'Mueller-Muller (decision-directed)', 'SamplesPerSymbol', sps,...
%                          'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Mueller & Muller


%comm = SymbolSynchronizer('TimingErrorDetector', 'Gardner (non-data-aided)', 'SamplesPerSymbol', sps, ...
%                          'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Gardner
                          
comm = SymbolSynchronizer('TimingErrorDetector', 'Early-Late (non-data-aided)', 'SamplesPerSymbol', sps, ...
                          'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Early-late

[xs, t] = step(comm, y);
%instants1 = step(comm1, y);              
%instants2 = step(comm2, y);              
%instants3 = step(comm3, y);

plot(y); hold on; plot(t, xs, 'r*')
              

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
