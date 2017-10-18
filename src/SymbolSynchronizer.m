classdef SymbolSynchronizer
    
  properties (Nontunable)
    % Especifica o tipo de sincronizador que sera utilizado:
    % Early-Late (Normal, NDA ou Decided) ou Zero-Crossing
    % Gardner (Normal ou Decided) ou Mueller & Muller
    % O default do Matlab eh o Zero-Crossing, porem aqui sera o Mueller & Muller
    TimingErrorDetector = 'Mueller-Muller';
    
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
  
    function s = step(obj, x)
      printf("%d\n", x)
    end 
  
  end % methods
  
end %class

% [EOF]

% Exemplo de Construtor
% a = SymbolSynchronizer('TimingErrorDetector', 'Early-Late', 'SamplesPerSymbol', ...
%     5, 'DampingFactor', 0.5, 'NormalizedLoopBandwidth', 0.005, 'DetectorGain', 2)