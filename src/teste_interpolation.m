clear all; close all; clc;

N = 4000;
tx = 2*randi([0,1], 1, N) - 1;

sps = 2;
rolloff = 0.5;
l = 50;
%offset = -1;
offset = 0;

h = srrc(l, rolloff, sps, offset);
r = upfirdn(tx, h, sps, 1);

%Ruidos aqui...
r = awgn(r, 20, 'measured');

matched = srrc(l, rolloff, sps, 0);
x = upfirdn(r, matched, 1, 1);

sps_ = sps*1.0;
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
%TNOW = [];

while tnow < length(x) - l*sps_
  i = i + 1;
  xs(i) = interpsinc(x, tnow+tau_hat, l);
  xb = interpsinc(x, tnow+tau_hat-sps_, l);
  err = (sign(xb)*xs(i)) - (sign(xs(i))*xb);
  tau_hat += err*alpha;
  sps_ += err*beta;
  tnow = tnow+sps_;
  %TNOW = [TNOW tnow];%
  TNOW(i) = tnow;
  tausave(i) = tau_hat;
end  

subplot(2,1,1), plot(x(round(TNOW))); hold on; plot(xs(sps:i-2), 'r*')
%plot(xs(1:i-2),'b.')       % plot constellation diagram
title('constellation diagram');
ylabel('estimated symbol values')
subplot(2,1,2), plot(tausave(1:i-2))       % plot trajectory of tau
ylabel('offset estimates'), xlabel('iterations')



%while k <= length(x) - 2*sps_
%  k = round(i + tau_hat);
%  k1 = round(i + tau_hat - sps_);
%  e = (sign(x(k1))*x(k)) - (sign(x(k))*x(k1));
%  tau_hat += e*alpha;
%  sps_ += e*beta;
%  wsmooth(j) = interpsinc(x, k, 1);
%  j += 1;
%  i += sps_;
%end

%while tnow<length(x)-l*m                   % run iteration
%  i=i+1;
%  xs(i)=interpsinc(x,tnow+tau,l);          % interpolated value at tnow+tau
%  x_deltap=interpsinc(x,tnow+tau+delta,l); % get value to the right
%  x_deltam=interpsinc(x,tnow+tau-delta,l); % get value to the left
%  dx=x_deltap-x_deltam;                    % calculate numerical derivative
%  tau=tau+mu*dx*xs(i);                     % alg update (energy)
%  tnow=tnow+m; tausave(i)=tau;             % save for plotting
%end




%N = 1000;
%bits = randi([0,1], 1, N);
%tx_signal = 2*bits - 1;
%
%sps = 5;
%Fa = 1.0;
%Rs = Fa*sps;
%t = (1:N*sps)/Fa;
%
%rolloff = 1;
%span = 20;
%h = squarerootrcosfilter(rolloff, span, sps);
%
%x = upfirdn(tx_signal, h, sps, 1);
%
%SNR = 15;
%r = awgn(x, SNR, 'measured');
%r = [0 0 0 0 r];
%
%y = upfirdn(r, h, 1, 1);
%x = y(1:N*sps);
%
%k = 0;
%tau_hat = 0;
%sps_ = sps*1.01;
%i = sps_ + 1;
%j = 1;
%
%bw = 0.01;
%damp = 1;
%alpha = (4*damp*bw)/(1 + 2*damp*bw + bw*bw);
%beta = (4*bw*bw)/(1 + 2*damp*bw + bw*bw);
%
%tnow = 1.0:sps:length(t);
%wsmooth = zeros(size(tnow));
%while k <= length(x) - 2*sps_
%  k = round(i + tau_hat);
%  k1 = round(i + tau_hat - sps_);
%  e = (sign(x(k1))*x(k)) - (sign(x(k))*x(k1));
%  tau_hat += e*alpha;
%  sps_ += e*beta;
%  wsmooth(j) = interpsinc(x, k, 1);
%  j += 1;
%  i += sps_;
%end
%
%plot(tnow,wsmooth,'*r')            % original=red & interpolated=blue
%hold on, plot(tnow,x(round(tnow)),'b')
%xlabel('time')
%ylabel('amplitude')
%hold off