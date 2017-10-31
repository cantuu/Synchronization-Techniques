classdef SymbolSynchronizer
    
  properties (Nontunable)
    % Especifica o tipo de sincronizador que sera utilizado:
    % Early-Late (Normal, NDA ou Decided) ou Zero-Crossing
    % Gardner (Normal ou Decided) ou Mueller & Muller
    % O default do Matlab eh o Zero-Crossing, porem aqui sera o Mueller & Muller
    % (Por enquanto... Zero-Crossing sera implementado)
    TimingErrorDetector = 'Mueller & Muller';
    
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
      #if obj.TimingErrorDetector == 'Mueller & Muller'
      #  s = obj.mueller_muller(y);
      #end
      if obj.TimingErrorDetector == 'Gardner'
        s = obj.gardner(y);
      end  
    end 
        
    function instants = mueller_muller(obj, y)
      k=0; tau_hat=0; instants=[];
      i = obj.SamplesPerSymbol + 1;
      
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor
      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw)
      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw)
      
      while k <= length(y) - 2*obj.SamplesPerSymbol
        k = round(i+tau_hat);
        k1 = round(i+tau_hat-obj.SamplesPerSymbol);
        e = (sign(y(k1))*y(k)) - (sign(y(k))*y(k1));
        obj.SamplesPerSymbol += e*beta;
        tau_hat += beta + e*alpha;
        instants = [instants k];
        i += obj.SamplesPerSymbol;
      end
    end
    
    function instants = gardner(obj, y)
      k=0; tau_hat=0; instants=[]; 
      tau_hat1 = 0;
      i = obj.SamplesPerSymbol + 1;
      
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      
      while k <= length(y) - 2*obj.SamplesPerSymbol
        k = round(i + tau_hat);
        k1 = round(i + tau_hat1 - obj.SamplesPerSymbol);
        k_half = ((k1 + k)/2);
        e = (y(k1) - y(k)) * y(round(k_half));
        obj.SamplesPerSymbol += e*beta;
        tau_hat1 = tau_hat;
        tau_hat += beta + e*alpha;
        instants = [instants k];
        i += obj.SamplesPerSymbol;
      end
    end    

    
  end % methods
  
end %class

% [EOF]