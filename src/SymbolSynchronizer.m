classdef SymbolSynchronizer
    
  properties (Nontunable)
    % Especifica o tipo de sincronizador que sera utilizado:
    % Early-Late (Normal, NDA ou Decided) ou Zero-Crossing
    % Gardner (Normal ou Decided) ou Mueller & Muller
    TimingErrorDetector = 'Zero-Crossing';
    
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
    Span = 50;
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
        end  
      end  
    end
  
    function [s, t] = step(obj, y)
      [s,t] = obj.TED(y);
    end
   
    function set_span(obj, span)
      obj.Span = span;
    end
    
    function reset(obj)
      obj.TimingErrorDetector = 'Zero-Crossing';
      obj.DampingFactor = 1;
      obj.NormalizedLoopBandwidth = 0.01;
      obj.DetectorGain = 2.7;
      obj.SamplesPerSymbol = 2;
    end
    
    function [instants time_instants] = TED(obj, y)
      instants = []; ret = [];
      obj.tnow = obj.Span*obj.SamplesPerSymbol + 1;
      obj.tau_hat = 0;
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
      
      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
      
      while obj.tnow < length(y) - obj.Span*obj.SamplesPerSymbol
        obj.tnow += obj.SamplesPerSymbol;
        ret = [ret obj.tnow+obj.tau_hat];
        xs = obj.interpolator(y, obj.tnow+obj.tau_hat, obj.Span);
        xb = obj.interpolator(y, obj.tnow+obj.tau_hat-obj.SamplesPerSymbol, obj.Span);
%        e = (sign(xb)*xs) - (sign(xs)*xb);
        e = obj.TEDChooser(y, xs, xb);
        obj.SamplesPerSymbol += e*beta;
        obj.tau_hat += e*alpha;
        instants = [instants xs];
        
      end
      time_instants = ret;
    end
    
%    function instants = TED(obj, y)
%      k=0; instants = [];
%      obj.i = obj.SamplesPerSymbol + 1;
%      obj.tau_hat = 0;
%      bw = obj.NormalizedLoopBandwidth;
%      damp = obj.DampingFactor;
%      
%      theta = bw/obj.SamplesPerSymbol/(damp + 0.25/damp);
%      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
%      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
%      
%      while k <= length(y) - 2*obj.SamplesPerSymbol
%        k = round(obj.i + obj.tau_hat);
%        k1 = round(obj.i + obj.tau_hat - obj.SamplesPerSymbol);
%        e = obj.TEDChooser(y, k, k1);
%        obj.SamplesPerSymbol += e*beta;
%        obj.tau_hat += e*alpha;
%        instants = [instants k];
%        obj.i += obj.SamplesPerSymbol;
%      end
%#      printf("%f\n", obj.tau_hat)
%#      printf("%f\n", obj.SamplesPerSymbol)
%    end
    
    function h = srrc(span, rolloff, oversamp, offset)
      if (rolloff == 0)
        beta=1e-8; 
      end;
      k = -span*oversamp+1e-8+offset:span*oversamp+1e-8+offset;
      s=4*rolloff/sqrt(oversamp)*(cos((1+rolloff)*pi*k/oversamp)+ ...      
        sin((1-rolloff)*pi*k/oversamp)./(4*rolloff*k/oversamp))./ ...
        (pi*(1-16*(rolloff*k/oversamp).^2));
    end  
    
    function samp = interpolator(obj, y, inst, span)
      current = round(inst);
      offset = inst - current;
      h = srrc(span, 0, 1, offset);
      y_hat = conv(y(current-span:current+span), h);
      samp = y_hat(2*span+1);
    end  
    
    function e = TEDChooser(obj, y, xs, xb)

      switch obj.TimingErrorDetector 
        case 'Zero-Crossing'
          obj.ErrPointer = TEDZeroCrossing(obj, y, xs, xb);  
        case 'Mueller & Muller'
          obj.ErrPointer = TEDMuellerMuller(obj, y, xs, xb);
        case 'Gardner'
          obj.ErrPointer = TEDGardner(obj, y, xs, xb);
        case 'Early-Late'
          samples = 3;
          obj.ErrPointer = TEDEarlyLate(obj, y, samples);
        otherwise
          e = error("Synchronizer does not exist");  
      end
      
      e = obj.ErrPointer;
    end
    
    function e = TEDMuellerMuller(obj, y, xs, xb)
      %e = (sign(y(k1))*y(k)) - (sign(y(k))*y(k1));
      e = (sign(xb)*xs) - (sign(xs)*xb);
    end 
    
    function e = TEDEarlyLate(obj, y, amostras)
      xs = obj.interpolator(y, obj.tnow+obj.tau_hat+amostras, obj.Span);
      xb = obj.interpolator(y, obj.tnow+obj.tau_hat-amostras, obj.Span);
      e = abs(xs) - abs(xb);
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
      XHalf = obj.interpolator(y, obj.tnow+obj.tau_hat-(obj.SamplesPerSymbol/2), obj.Span);
    end
    
  end % methods
  
end %class

% [EOF]
