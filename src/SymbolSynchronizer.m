classdef SymbolSynchronizer
    
  properties (Nontunable)
    % Especifica o tipo de sincronizador que sera utilizado:
    % Early-Late (Normal, NDA ou Decided) ou Zero-Crossing
    % Gardner (Normal ou Decided) ou Mueller & Muller
    TimingErrorDetector = 'Zero-Crossing (decision-directed)';
    
    % Especifica o numero de amostras por simbolo, sendo um numero real, inteiro,
    % escalar e maior igual a 2. O default do Matlab eh 2.
    SamplesPerSymbol = 2;
  end
  
  properties
    % As seguintes propriedades setam os ganhos proporcionais e intergrais do 
    % loop filter. Todas elas ja assumem um valor default, caso o usuario nao passe.
    DampingFactor = 1;
    NormalizedLoopBandwidth = 0.01;
    DetectorGain = 2.7;
    RolloffFactor = 0.2;
    FilterSpanInSymbols = 10;
  end
  
  properties(Constant, Hidden)
    % Especifica quais os valores que o TimingErrorDetector pode assumir
    TimingErrorDetectorSet = [...
        'Early-Late'; 'Early-Late Decided'; 'Early-Late NDA'; ...
        'Gardner'; 'Gardner Decided'; 'Mueller & Muller'];
  end
  
  properties(Access = private)
    ErrPointer;
    tnow;
    tau_hat;
  end
  

  methods
    % Construtor e inicializaçao de variaveis
    % ATENÇAO! REALIZAR A VERIFICAÇAO DAS VARIAVEIS (ver se bate com os requisitos...)
    function obj = SymbolSynchronizer(varargin)
      for i = 1:length(varargin)
        if(strcmp(varargin{i}, 'TimingErrorDetector'))
          obj.TimingErrorDetector = varargin{i+1};
        elseif(strcmp(varargin{i}, 'SamplesPerSymbol'))
          obj.SamplesPerSymbol = varargin{i+1};  
        elseif(strcmp(varargin{i}, 'DampingFactor'))
          obj.DampingFactor = varargin{i+1};
        elseif(strcmp(varargin{i}, 'NormalizedLoopBandwidth'))
          obj.NormalizedLoopBandwidth  = varargin{i+1};
        elseif(strcmp(varargin{i}, 'DetectorGain'))
          obj.DetectorGain = varargin{i+1};
        elseif(strcmp(varargin{i}, 'RolloffFactor'))
          obj.RolloffFactor = varargin{i+1};
        elseif(strcmp(varargin{i}, 'FilterSpanInSymbols'))
          obj.FilterSpanInSymbols = varargin{i+1};  
        end  
      end  
    end
  
    function [s, t] = step(obj, y)
      [s,t] = obj.TED(y);
    end
    
    function reset(obj)
      obj.TimingErrorDetector = 'Zero-Crossing (decision-directed)';
      obj.DampingFactor = 1;
      obj.NormalizedLoopBandwidth = 0.01;
      obj.DetectorGain = 2.7;
      obj.SamplesPerSymbol = 2;
    end
    
    function [corrected_sig timing_error] = TED(obj, y)
      corrected_sig = []; 
      te = [];
      obj.tnow = obj.FilterSpanInSymbols*obj.SamplesPerSymbol + 1;
      obj.tau_hat = 0;
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
      
      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
      while obj.tnow < length(y) - obj.FilterSpanInSymbols*obj.SamplesPerSymbol
        obj.tnow += obj.SamplesPerSymbol;
        
        
        te = [te obj.tnow+obj.tau_hat];
        xs = obj.interpolator(y, obj.tnow+obj.tau_hat);
        xb = obj.interpolator(y, obj.tnow+obj.tau_hat-obj.SamplesPerSymbol);
        e = obj.TEDChooser(y, xs, xb);
        obj.SamplesPerSymbol += e*beta;
        obj.tau_hat += e*alpha;
        corrected_sig = [corrected_sig xs];
        
      end
      timing_error = te;
    end
    
    function samp = interpolator(obj, y, inst)
      span = obj.FilterSpanInSymbols;
      current = round(inst);
      offset = inst - current;
      h = obj.srrc(offset);
      y_hat = conv(y(current-span:current+span), h);
      samp = y_hat(2*span+1);
    end 
    
    function h = srrc(obj, offset)
      rolloff = obj.RolloffFactor;
      span = obj.FilterSpanInSymbols;
      if (rolloff == 0)
        rolloff=1e-8; 
      end;
      k = -span+1e-8+offset:span+1e-8+offset;
      h=4*rolloff*(cos((1+rolloff)*pi*k)+ ...      
        sin((1-rolloff)*pi*k)./(4*rolloff*k))./ ...
        (pi*(1-16*(rolloff*k).^2));
    end   
    
    function e = TEDChooser(obj, y, xs, xb)

      switch obj.TimingErrorDetector 
        case 'Zero-Crossing (decision-directed)'
          obj.ErrPointer = TEDZeroCrossing(obj, y, xs, xb);  
        case 'Mueller-Muller (decision-directed)'
          obj.ErrPointer = TEDMuellerMuller(obj, y, xs, xb);
        case 'Gardner (non-data-aided)'
          obj.ErrPointer = TEDGardner(obj, y, xs, xb);
        case 'Early-Late (non-data-aided)'
          obj.ErrPointer = TEDEarlyLate(obj, y, xs);
        otherwise
          e = error("Synchronizer does not exist");  
      end
      
      e = obj.ErrPointer;
    end
    
    function e = TEDMuellerMuller(obj, y, xs, xb)
      e = (sign(xb)*xs) - (sign(xs)*xb);
    end 
    
    function e = TEDEarlyLate(obj, y, xs)
      xl = obj.interpolator(y, obj.tnow+obj.tau_hat+(obj.SamplesPerSymbol/2));
      xe = obj.interpolator(y, obj.tnow+obj.tau_hat-(obj.SamplesPerSymbol/2));
      e = xs * (xl - xe);
    end
    
    function e = TEDGardner(obj, y, xs, xb)
      xh = obj.KMiddle(y);
      e = (xb-xs) * xh;      
    end
    
    function e = TEDZeroCrossing(obj, y, xs, xb)
      xh = obj.KMiddle(y);
      e = (sign(xb) - sign(xs)) * xh;
    end
        
    function XHalf = KMiddle(obj, y)
      XHalf = obj.interpolator(y, obj.tnow+obj.tau_hat-(obj.SamplesPerSymbol/2));
    end
    
  end % methods
  
end %class

% [EOF]
