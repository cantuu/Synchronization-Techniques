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

srrc = SquareRootRaisedCosineFilter('FilterSpanInSymbols', l, 'RolloffFactor', rolloff, ...
                                    'DecimationFactor', sps, 'DecimationOffset', offset);

h = srrc.step();  
r = upfirdn(tx, h, sps, 1);

r = awgn(r, 100, 'measured');
r = [zeros(1,3) r];

y = upfirdn(r, h, 1, 1);

sps = sps*1.001;

ss = SymbolSynchronizer('SamplesPerSymbol', sps*1.001, 'NormalizedLoopBandwidth', 0.01, ...
                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Zero-Crossing

%ss = SymbolSynchronizer('TimingErrorDetector', 'Mueller-Muller (decision-directed)', 'SamplesPerSymbol', sps,...
%                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Mueller & Muller


%ss = SymbolSynchronizer('TimingErrorDetector', 'Gardner (non-data-aided)', 'SamplesPerSymbol', sps, ...
%                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Gardner
                          
%ss = SymbolSynchronizer('TimingErrorDetector', 'Early-Late (non-data-aided)', 'SamplesPerSymbol', sps, ...
%                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', l); %Early-late

%ss = SymbolSynchronizer('TimingErrorDetector', 'Mueller-Muller (decision-directed)', 'SamplesPerSymbol', sps,...
%                        'SRRCFilter', srrc); %Mueller & Muller


[xs, t] = step(ss, y);

plot(y); hold on; plot(t, xs, 'r*')
              
%reset(ss);
    
% Exemplo de Construtor
% a = SymbolSynchronizer('TimingErrorDetector', 'Early-Late', 'SamplesPerSymbol', ...
%     5, 'DampingFactor', 0.5, 'NormalizedLoopBandwidth', 0.005, 'DetectorGain', 2)    
    
# [EOF]    