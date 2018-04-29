% File created to test the SymbolSynchronizer class, implemented to
% this project to be an alternative to package comm.SymbolSynchronizer
% from Matlab

clear all; close all; clc;

N = 4000;
tx = 2*randi([0,1], 1, N) - 1;

sps = 10;
rolloff = 0.5;
span = 50;
offset = 0;

vm = ver('matlab');
vo = ver('octave');
if isequal(size(vm), [1 1])
    if strcmp(vm.Name, 'MATLAB')
        ss = comm.SymbolSynchronizer('SamplesPerSymbol', sps, 'NormalizedLoopBandwidth', 0.01);
    else
        error('Program Name does not exist')
    end
elseif isequal(size(vo), [1 1])
    if strcmp(vo.Name, 'Octave')
        ss = SymbolSynchronizer('SamplesPerSymbol', sps, 'NormalizedLoopBandwidth', 0.01, ...
                                'RolloffFactor', rolloff, 'FilterSpanInSymbols', span); %Zero-Crossing
    else
        error('Program Name does not exist')
    end
else
    error('Versions matrix dimensions does not match')
end 

h = srrc(span, rolloff, sps, offset);
%h = rcosdesign(rolloff, span, sps);

r = upfirdn(tx, h, sps, 1);
r = awgn(r, 100, 'measured');
r = [zeros(1,3) r];

y = upfirdn(r, h, 1, 1);

sps = sps*1.001;

[xs, P] = step(ss, y');

t = (1:length(y))';

%ts1 = sps*(0:length(xs)-1)';% + P(sps:sps:end);
%ts2 = P(sps:sps:end);

plot(t, y); hold on; plot(P, xs, 'r*')
    
        
%reset(ss);
    
% Exemplos de Construtores
%ss = SymbolSynchronizer('SamplesPerSymbol', sps, 'NormalizedLoopBandwidth', 0.01, ...
%                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', span); %Zero-Crossing

%ss = SymbolSynchronizer('TimingErrorDetector', 'Mueller-Muller (decision-directed)', 'SamplesPerSymbol', sps,...
%                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', span); %Mueller & Muller


%ss = SymbolSynchronizer('TimingErrorDetector', 'Gardner (non-data-aided)', 'SamplesPerSymbol', sps, ...
%                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', span); %Gardner
                          
%ss = SymbolSynchronizer('TimingErrorDetector', 'Early-Late (non-data-aided)', 'SamplesPerSymbol', sps, ...
%                        'RolloffFactor', rolloff, 'FilterSpanInSymbols', span); %Early-late
    
% [EOF]    