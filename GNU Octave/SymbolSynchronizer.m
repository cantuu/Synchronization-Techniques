classdef SymbolSynchronizer
    
  properties
    Modulation
    TimingErrorDetector
    SamplesPerSymbol
    DampingFactor
    NormalizedLoopBandwidth
    DetectorGain
  end
  
  methods
    function obj = SymbolSynchronizer(modulation, ted, sps, df, nlb, dg)
      obj.Modulation = modulation;
      obj.TimingErrorDetector = ted;
      obj.SamplesPerSymbol = sps;
      obj.DampingFactor = df;
      obj.NormalizedLoopBandwidth = nlb;
      obj.DetectorGain = dg;    
    end
    
    % ... segue as funçoes
  end

end

% Exemplo de Construtor:
%   a = SymbolSynchronizer('BPSK', 'Early-Late', 2, 1, 0.01, 2.7)