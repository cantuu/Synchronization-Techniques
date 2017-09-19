clear all; close all; clc;

% Parametros
N = 1000;
sps = 40;

Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;

amostras_el = 3;
samples = 5;
tau = 1; 
mi = 0.5;
Eb_N0 = 100;

SPS = [sps-4:0.1:sps+4];

a = 50;
conv_el = zeros(a,length(SPS)); conv_el_dec = zeros(a,length(SPS)); 
conv_el_nda = zeros(a,length(SPS)); conv_mm = zeros(a,length(SPS));
conv_g = zeros(a,length(SPS)); conv_g_d = zeros(a,length(SPS));

for j = 1:a  
  j 
  fflush(stdout);
  for i = 1:length(SPS)
      bits = randi([0 1], 1, N);
      y1 = tx_chan(bits, N, sps, Eb_N0, 0);     
      
      instants1 = early_late(y1, SPS(i), amostras_el, tau, mi);
      conv_el(j,i) = convergencia(y1, instants1, samples, sps);
      
      instants2 = early_late_decided(y1, SPS(i), amostras_el, tau, mi);
      conv_el_dec(j,i) = convergencia(y1, instants2, samples, sps);
      
      instants3 = early_late_nda(y1, SPS(i), amostras_el, tau, mi);
      conv_el_nda(j,i) = convergencia(y1, instants3, samples, sps);
      
      instants4 = mueller_and_mueller(y1, SPS(i), tau, mi);
      conv_mm(j,i) = convergencia(y1, instants4, samples, sps);
      
      instants5 = gardner(y1, SPS(i), tau, mi);
      conv_g(j,i) = convergencia(y1, instants5, samples, sps);
      
      instants6 = gardner(y1, SPS(i), tau, mi);
      conv_g_d(j,i) = convergencia(y1, instants6, samples, sps);
  end
end

conv_el_avg = mean(conv_el);
conv_el_dec_avg = mean(conv_el_dec);
conv_el_nda_avg = mean(conv_el_nda);
conv_mm_avg = mean(conv_mm);
conv_g_avg = mean(conv_g);
conv_g_d_avg = mean(conv_g_d);

_sps = SPS - sps;

figure(1); 
subplot(131)
plot(_sps, conv_el_avg, 'b'); hold on;
plot(_sps, conv_el_dec_avg, 'r'); 
plot(_sps, conv_el_nda_avg, 'g'); %hold off;
legend('Early-Late', 'Early-Late Decided', 'Early-Late NDA');

subplot(132) ;
plot(_sps, conv_mm_avg, 'r');
legend('Muller & Muller');

subplot(133)
plot(_sps, conv_g_avg, 'g');
plot(_sps, conv_g_d_avg, 'r'); hold off
legend('Gardner', 'Gardner Decided')