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
    TEDpointer
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
      switch obj.TimingErrorDetector 
        case 'Mueller & Muller'
          obj.TEDpointer = mueller_muller(obj, y);
          printf("MM\n")
        case 'Gardner'
          obj.TEDpointer = gardner(obj, y);
        case 'Early-Late'
          obj.TEDpointer = early_late(obj, y);
        case 'Zero-Crossing'
          obj.TEDpointer = zero_crossing(obj, y);  
          printf("ZC\n")
        otherwise
          s = error("Synchronizer does not exist");  
      end
      
      s = obj.TEDpointer;
    end 
    
    function reset(obj)
      obj.TimingErrorDetector = 'Zero-Crossing';
      obj.DampingFactor = 1;
      obj.NormalizedLoopBandwidth = 0.01;
      obj.DetectorGain = 2.7;
      obj.SamplesPerSymbol = 2;

    end
        
    function instants = mueller_muller(obj, y)
      k=0; tau_hat=0; instants=[];
      i = obj.SamplesPerSymbol + 1;
      
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
%      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
%      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      theta = bw/obj.SamplesPerSymbol/(damp + 0.25/damp);
<<<<<<< HEAD
      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
=======
      alpha = (4*damp*theta)/(1 + 2*damp*theta + theta*theta); #K1
      beta = (4*theta*theta)/(1 + 2*damp*theta + theta*theta); #K2      
>>>>>>> parent of ad27e1c... Code Optimization - Delay added to original Signal
      
      while k <= length(y) - 2*obj.SamplesPerSymbol
        k = round(i+tau_hat);
        k1 = round(i+tau_hat-obj.SamplesPerSymbol);
        e = (sign(y(k1))*y(k)) - (sign(y(k))*y(k1));
        obj.SamplesPerSymbol += e*beta;
<<<<<<< HEAD
        obj.tau_hat += e*alpha;
=======
        tau_hat += beta + e*alpha;
>>>>>>> parent of ad27e1c... Code Optimization - Delay added to original Signal
        instants = [instants k];
        i += obj.SamplesPerSymbol;
      end
      printf("%f\n", obj.tau_hat)
      printf("%f\n", obj.SamplesPerSymbol)
    end
    
    function instants = gardner(obj, y)
      k=0; tau_hat=0; instants=[]; 
      i = obj.SamplesPerSymbol + 1;
      
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
%      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
%      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      theta = bw/obj.SamplesPerSymbol/(damp + 0.25/damp);
      alpha = (4*damp*theta)/(1 + 2*damp*theta + theta*theta); #K1
      beta = (4*theta*theta)/(1 + 2*damp*theta + theta*theta); #K2
      
      while k <= length(y) - 2*obj.SamplesPerSymbol
        k = round(i + tau_hat);
        k1 = round(i + tau_hat - obj.SamplesPerSymbol);
        #k_half = ((k1 + k)/2);
        #e = (y(k1) - y(k)) * y(round(k_half));
        k_half = round(i + tau_hat - obj.SamplesPerSymbol/2);
        e = (y(k)-y(k1)) * (y(k_half));
        obj.SamplesPerSymbol += e*beta;
        tau_hat += beta + e*alpha;
        instants = [instants k];
        i += obj.SamplesPerSymbol;
      end
    end    

    function instants = early_late(obj, y)
      instants = []; tau_hat = 0; k = 0;
      i = obj.SamplesPerSymbol  + 1;    

      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
%      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
%      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);      
      theta = bw/obj.SamplesPerSymbol/(damp + 0.25/damp);
      alpha = (4*damp*theta)/(1 + 2*damp*theta + theta*theta); #K1
      beta = (4*theta*theta)/(1 + 2*damp*theta + theta*theta); #K2
      amostras = 3;  
      
<<<<<<< HEAD
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
=======
      while k <=  length(y) - 2*obj.SamplesPerSymbol
        k = round(i + tau_hat);
        e = abs(y(k+amostras)) - abs(y(k-amostras));
        obj.SamplesPerSymbol += e*beta;
        tau_hat += beta + e*alpha;
        instants = [instants k];
        i += obj.SamplesPerSymbol;
      end
    end
    
    function instants = zero_crossing(obj, y)
      k=0; tau_hat=0; instants=[]; 
      i = obj.SamplesPerSymbol + 1;
      
      bw = obj.NormalizedLoopBandwidth;
      damp = obj.DampingFactor;
%      beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
%      alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
      theta = bw/obj.SamplesPerSymbol/(damp + 0.25/damp);
      alpha = (4*damp*theta)/(1 + 2*damp*theta + theta*theta); #K1
      beta = (4*theta*theta)/(1 + 2*damp*theta + theta*theta); #K2
      
      while k <= length(y) - 2*obj.SamplesPerSymbol
        k = round(i + tau_hat);
        k1 = round(i + tau_hat - obj.SamplesPerSymbol);
        k_half = round(i + tau_hat - obj.SamplesPerSymbol/2);
        e = (sign(y(k1)) - (sign(y(k)))) * y(k_half);
        obj.SamplesPerSymbol += e*beta;
        tau_hat += beta + e*alpha;
        instants = [instants k];
        i += obj.SamplesPerSymbol;
      end
    end    
>>>>>>> parent of ad27e1c... Code Optimization - Delay added to original Signal
    
  end % methods
  
end %class

% [EOF]