classdef RaisedCosineTransmitFilter #< handle

  properties
    RolloffFactor = 0.2;
    FilterSpanInSymbols = 10;
    OutputSamplesPerSymbol = 8;
  end
  
  methods
  
    function obj = RaisedCosineTransmitFilter(varargin)
      for i = 1:length(varargin)
        if(strcmp(varargin{i}, 'RolloffFactor'))
          obj.RolloffFactor = varargin{i+1};
        elseif(strcmp(varargin{i}, 'FilterSpanInSymbols'))
          obj.FilterSpanInSymbols = varargin{i+1};  
        elseif(strcmp(varargin{i}, 'OutputSamplesPerSymbol'))
          obj.OutputSamplesPerSymbol = varargin{i+1};  
        elseif(strcmp(varargin{i}, 'DecimationOffset'))
          obj.DecimationOffset = varargin{i+1};  
        end  
      end  
    end
    
    function h = step(obj)
      rolloff = obj.RolloffFactor;
      span = obj.FilterSpanInSymbols;
      offset = 0;
      oversamp = obj.OutputSamplesPerSymbol;
      
      if (rolloff == 0)
          rolloff=1e-8; 
      end;
      k = -span*oversamp+1e-8+offset:span*oversamp+1e-8+offset;
      h=4*rolloff/sqrt(oversamp)*(cos((1+rolloff)*pi*k/oversamp)+ ...      
        sin((1-rolloff)*pi*k/oversamp)./(4*rolloff*k/oversamp))./ ...
        (pi*(1-16*(rolloff*k/oversamp).^2));
    end
    
    function reset(obj)
      obj.RolloffFactor = 0.2;
      obj.FilterSpanInSymbols = 10;
      obj.OutputSamplesPerSymbol = 8;
    end  
  
  end %methods
  
end % class 
   
% [EOF]   