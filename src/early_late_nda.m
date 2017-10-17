function instants6 = early_late_nda (y, sps_, amostras, mi_tau, mi_sps);

instants6 = [];
tau_hat = 0;
k = 0;
i = sps_ + 1;

while k <= (length(y) - 2*sps_)
  k = round(i + tau_hat);
  e = (y(k)) * (y(k+amostras) - y(k-amostras));
  tau_hat += mi_tau*e;
  sps_ += mi_sps*e;
  instants6 = [instants6 k];
  i += sps_;
end
end