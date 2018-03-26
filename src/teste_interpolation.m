clear all; close all; clc;

N = 4000;
tx = 2*randi([0,1], 1, N) - 1;

sps = 10;
rolloff = 0.5;
l = 50;
%offset = -1;
offset = 0;

h = srrc(l, rolloff, sps, offset);
r = upfirdn(tx, h, sps, 1);

r = awgn(r, 20, 'measured');
r = [0 0 0 r];

matched = srrc(l, rolloff, sps, 0);
x = upfirdn(r, matched, 1, 1);

sps_ = sps*1.00;
tnow = l*sps + 1; 
tau_hat = 0;
xs = zeros(1,N);
tausave = zeros(1,N); tausave(1) = tau_hat;
i = 0;
bw = 0.01;
damp = 1;
alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
TNOW = zeros(1,N);

while tnow < length(x) - l*sps_
  i = i + 1;
  xs(i) = interpsinc(x, tnow+tau_hat, l);
  xb = interpsinc(x, tnow+tau_hat-sps_, l);
  err = (sign(xb)*xs(i)) - (sign(xs(i))*xb);
  tau_hat += err*alpha;
  sps_ += err*beta;
  tnow = tnow+sps_;
  TNOW(i) = tnow;
  tausave(i) = tau_hat;
end  

subplot(2,1,1), plot(x); hold on; plot(TNOW(1:end-1), xs(2:end), 'r*')
title('constellation diagram');
ylabel('estimated symbol values')
subplot(2,1,2), plot(tausave(1:i-2))       % plot trajectory of tau
ylabel('offset estimates'), xlabel('iterations')

% [EOF]
