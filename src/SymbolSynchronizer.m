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
  end
  
  properties(Constant, Hidden)
    % Especifica quais os valores que o TimingErrorDetector pode assumir
    TimingErrorDetectorSet = [...
        'Early-Late'; 'Early-Late Decided'; 'Early-Late NDA'; ...
        'Gardner'; 'Gardner Decided'; 'Mueller & Muller'];
  end
  
  properties(Access = private)
    ErrPointer;
    i;
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
  
    function s = step(obj, y)
      s = obj.TED(y);
    end 
    
    function reset(obj)
      obj.TimingErrorDetector = 'Zero-Crossing';
      obj.DampingFactor = 1;
      obj.NormalizedLoopBandwidth = 0.01;
      obj.DetectorGain = 2.7;
      obj.SamplesPerSymbol = 2;
    end
    
    function instants = TED(obj, y)
      k=0; instants = [];
      obj.i = obj.SamplesPerSymbol + 1;
      obj.tau_hat = 0;
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
      
      theta = bw/obj.SamplesPerSymbol/(damp + 0.25/damp);
      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
      
      while k <= length(y) - 2*obj.SamplesPerSymbol
        k = round(obj.i + obj.tau_hat);
        k1 = round(obj.i + obj.tau_hat - obj.SamplesPerSymbol);
        e = obj.TEDChooser(y, k, k1);
        obj.SamplesPerSymbol += e*beta;
        obj.tau_hat += e*alpha;
        instants = [instants k];
        obj.i += obj.SamplesPerSymbol;
      end
      printf("%f\n", obj.tau_hat)
      printf("%f\n", obj.SamplesPerSymbol)
    end
    
    function e = TEDChooser(obj, y, k, k1)

      switch obj.TimingErrorDetector 
        case 'Zero-Crossing'
          obj.ErrPointer = TEDZeroCrossing(obj, y, k, k1);  
        case 'Mueller & Muller'
          obj.ErrPointer = TEDMuellerMuller(obj, y, k, k1);
        case 'Gardner'
          obj.ErrPointer = TEDGardner(obj, y, k, k1);
        case 'Early-Late'
          samples = 3;
          obj.ErrPointer = TEDEarlyLate(obj, y, k, samples);
        otherwise
          e = error("Synchronizer does not exist");  
      end
      
      e = obj.ErrPointer;
    end
    
    function e = TEDMuellerMuller(obj, y, k, k1)
      e = (sign(y(k1))*y(k)) - (sign(y(k))*y(k1));
    end 
    
    function e = TEDEarlyLate(obj, y, k, amostras)
      e = abs(y(k+amostras)) - abs(y(k-amostras));
    end
    
    function e = TEDGardner(obj, y, k, k1)
      k_half = (k+k1)/2; #obj.KMiddle;
      e = (y(k)-y(k1)) * y(round(k_half));      
    end
    
    function e = TEDZeroCrossing(obj, y, k, k1)
      #k_half = obj.KMiddle;
      k_half = (k+k1)/2;
      e = (sign(y(k1)) - sign(y(k))) * y(round(k_half));
    end
        
    function KHalf = KMiddle(obj)
      KHalf = obj.i + obj.tau_hat - obj.SamplesPerSymbol/2;
    end
    
  end % methods
  
end %class

% [EOF]
