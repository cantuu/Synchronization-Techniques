function instants = mmd (y, sps_, damp, bw);

k=0; instants=[];
tau_hat=0;
i = sps_ + 1;

alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);

while k <= length(y) - 2*sps_
  k = round(i+tau_hat);
  k1 = round(i+tau_hat-sps_);
  e = (sign(y(k1))*y(k)) - (sign(y(k))*y(k1));
  sps_ += beta*e;
  tau_hat += sps_ + alpha*e;
  instants = [instants k];
  i += sps_;
end


end
%k = 0;
%instants3 = [];
%tau_had = 0;
%i = sps_ + 1;
%
%while k <= length(y) - 2*sps_
%  k = round (i + tau_had);
%  k1 = round (i + tau_had - sps_); 
%  e = (sign(y(k1))*y(k)) - (sign(y(k))*y(k1));
%  tau_had += mi_tau*e;
%  sps_ += mi_sps*e;
%  instants3 = [instants3 k];
%  i += sps_;  
% end 
  