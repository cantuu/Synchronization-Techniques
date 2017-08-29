function instants3 = mueller_and_mueller (y, sps_, mi_tau, mi_sps);

k = 0;
instants3 = [];
tau_had = 0;
i = sps_ + 1;

while k <= length(y) - 2*sps_
  k = round (i + tau_had);
  k1 = round (i + tau_had - sps_); 
  e = (sign(y(k1))*y(k)) - (sign(y(k))*y(k1));
  tau_had += mi_tau*e;
  sps_ += mi_sps*e;
  instants3 = [instants3 k];
  i += sps_;  
 end 
  
end
