
function instants2 = gardner(y, sps_, mi_tau, mi_sps)

instants2 = [];
tau_hat = 0;
k = 0;
i = sps_+1;
tam = length(y);

while k <=  length(y) - 2*sps_
  k = round(i + tau_hat);
  k1 = round(i + tau_hat - sps_);
  k_half = round((k1 + k)/2);
  e = (y(k1) - y(k)) * y(k_half);
  tau_hat += mi_tau * e;
  sps_ += mi_sps*e;
  instants2 = [instants2 k];
  i += sps_;
end
end