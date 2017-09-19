function conv  = convergencia(y, instants, samples,sps)

  y_out = zeros(1,length(instants));
  inst_atual = 0;
  y_atual = 0;
  aux = 0;
  limiar = 0.7;
  looksamples = 20;
  conv_init = 0;

  for i = 1:length(instants)
      y_out(i) = y(instants(i));
  end  

  for i = 1:length(instants)-4*looksamples
      y_slice = abs(y_out(i:i+looksamples-1));
      y_lim = y_slice < limiar;
      if (sum(y_lim) >= samples)
          conv_init = instants(i);
      endif
  end
  
  conv = conv_init/sps;
  %for i = 1:length(instants)-samples
  %    a = abs(y_out(i:i+samples-1)) < limiar;
  %    if (all(a))
  %        aux = instants(i);
  %    endif
  %end
  %conv_init = conv_init/sps

end