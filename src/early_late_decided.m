function instants5 = early_late_decided(y, sps_, amostras, mi_tau, mi_sps);

tau_hat = 0;
instants5 = [];
k = 0;
i = sps_ + 1;

while k <=  length(y) - 2*sps_
  k = round(i + tau_hat);
  e = sign(y(k)) * (y(k+amostras) - y(k-amostras));
  tau_hat += mi_tau*e;
  sps_ += mi_sps*e;
  instants5 = [instants5 k];
  i += sps_;
end;
end;
