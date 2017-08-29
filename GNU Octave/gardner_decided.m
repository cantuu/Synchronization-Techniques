function instants4 = gardner_decided(y, sps_, mi_tau, mi_sps)

instants4 = [];
tau_hat = 0;
k = 0;
i = sps_ + 1;
tam = length(y);

while k <= length(y) - (2*sps_) 
  k = round (i + tau_hat);
  k1 = round (i + tau_hat - sps_);
  k_half = (k + k1)/2;
  e = (sign(y(k1)) - sign(y(k))) * y(floor(k_half));
  tau_hat += mi_tau*e;
  sps_ += mi_sps*e;
  instants4 = [instants4 k];
  i += sps_;
end
end