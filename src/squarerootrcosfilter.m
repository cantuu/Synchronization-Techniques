function b = squarerootrcosfilter(beta, span, sps)

  delay = span*sps/2;
  t = (-delay:delay)/sps;
  
  % Find mid-point
  idx1 = find(t==0);
  if ~isempty(idx1)
    b(idx1) = -1 ./ (pi.*sps) .* (pi.*(beta-1) - 4.*beta);
  end
  
  % Find non-zero denominator indices
  idx2 = find(abs(abs(4.*beta.*t) - 1.0) < sqrt(eps));
  if ~isempty(idx2)
    b(idx2) = 1 ./ (2.*pi.*sps) ...
      * (    pi.*(beta+1)  .* sin(pi.*(beta+1)./(4.*beta)) ...
      - 4.*beta     .* sin(pi.*(beta-1)./(4.*beta)) ...
      + pi.*(beta-1)  .* cos(pi.*(beta-1)./(4.*beta)) ...
      );
  end
  
  % Fill in the zeros denominator indices
  ind = 1:length(t);
  ind([idx1 idx2]) = [];
  nind = t(ind);
  
  b(ind) = -4.*beta./sps .* ( cos((1+beta).*pi.*nind) + ...
    sin((1-beta).*pi.*nind) ./ (4.*beta.*nind) ) ...
    ./ (pi .* ((4.*beta.*nind).^2 - 1));

  % Normalize filter energy
  b = b / sqrt(sum(b.^2));  
    
end

% [EOF]