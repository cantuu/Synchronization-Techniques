close all; clear all; 

#Change plot graphics_toolkit ("gnuplot") or graphics_toolkit ("fltk")

%Parametros
N = 1000;
bits = randi ([0,1], 1, N);
x = 2.*bits - 1;
sps = 40;
Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;
snr_db = 20;
amostras = 3;
mi_tau = 1;
mi_sps = 0.5;

sps_ = sps * 1.01;

%Tx
Hs = ones(1,sps);
up = upsample (x, sps);
s = conv(Hs, up);
s = s(1:N*sps);
subplot(211); plot(s); xlim([0 5000]); ylim([-2 2]);

%Canal
%delta = randi([0,sps-1]); 
delta = 5*sps + 21;
s_atrasado = [zeros(1, delta) s];
s_atrasado = s_atrasado(1:N*sps);
r = awgn (s_atrasado, snr_db - 10*log10(sps));
subplot(212); plot(r); xlim([0 5000]);

%Rx
Hr = fliplr(Hs); %Inverte o sinal da esquerda para a direita
y = (conv(r, Hr)) / sps; %filtro casado;
y = y(1:N*sps);

% Analise Convergencia/SNR
samples = 7;
SNR = [0:30]; 
a = 1;
conv_el = zeros(a,length(SNR)); conv_el_dec = zeros(a,length(SNR)); 
conv_el_nda = zeros(a,length(SNR)); conv_mm = zeros(a,length(SNR));
conv_g = zeros(a,length(SNR)); conv_g_d = zeros(a,length(SNR));

for j = 1:a
  bits = randi ([0,1], 1, N); 
  x = 2.*bits - 1;

  Hs = ones(1,sps);
  up = upsample (x, sps);
  s = conv(Hs, up);
  s = s(1:N*sps);
  for i = 1:length(SNR)
      %Canal
      %delta = randi([0,sps-1]); 
      delta = 5*sps + 21;
      s_atrasado = [zeros(1, delta) s];
      s_atrasado = s_atrasado(1:N*sps);

      r1 = awgn(s_atrasado, SNR(i) - 10*log10(sps));
      y1 = (conv(r1, Hr))/sps;
      y1 = y1(1:N*sps);
      
      instants1 = early_late(y, sps_, amostras, mi_tau, mi_sps);
      conv_el(j,i) = convergencia(y1, instants1, samples, sps);
      
      instants2 = early_late_decided(y, sps_, amostras, mi_tau, mi_sps);
      conv_el_dec(j,i) = convergencia(y1, instants2, samples, sps);
      
      instants3 = early_late_nda(y, sps_, amostras, mi_tau, mi_sps);
      conv_el_nda(j,i) = convergencia(y1, instants3, samples, sps);
      
      instants4 = mueller_and_mueller(y, sps_, mi_tau, mi_sps);
      conv_mm(j,i) = convergencia(y1, instants4, samples, sps);
      
      instants5 = gardner(y, sps_, mi_tau, mi_sps);
      conv_g(j,i) = convergencia(y1, instants5, samples, sps);
      
      instants6 = gardner(y, sps_, mi_tau, mi_sps);
      conv_g_d(j,i) = convergencia(y1, instants6, samples, sps);
  end
end
conv_el_avg = mean(conv_el);
conv_el_dec_avg = mean(conv_el_dec);
conv_el_nda_avg = mean(conv_el_nda);
conv_mm_avg = mean(conv_mm);
figure(2); 
subplot(121)
plot(SNR, conv_el_avg, 'b'); hold on;
plot(SNR, conv_el_dec_avg, 'r'); 
plot(SNR, conv_el_nda_avg, 'g'); hold off;
legend('Early-Late', 'Early-Late Decided', 'Early-Late NDA');

subplot(122) ;
plot(SNR, conv_mm_avg, 'r');
legend('Muller & Muller');

figure(3)
plot(SNR, conv_g, 'g'); %hold on;
%plot(SNR, conv_g_d, 'r'); hold off;
%legend('Gardner', 'Gardner Decided')


%%Chamada do sincronizador open_loop
%figure(2)
%instants = open_loop (y, Fa, Rs);
%plot(t, y); xlim([0 1000]); grid on;
%hold on;
%plot(t(instants), y(instants), 'ro'); xlim([0 1000]);
%title('Sincronizador de malha aberta')
%Chamada do sincronizador early_late

%figure(3)
%instants1 = early_late(y, sps_, amostras, mi_tau, mi_sps);
%subplot(311); plot(t, y); xlim([0 500]); grid on;
%hold on; 
%subplot(311); plot(t(instants1), y(instants1), 'ro'); xlim([0 500]);
%title('Sincronizador Early-Late')

%%figure(4)
%instants5 = early_late_decided(y, sps_, amostras, mi_tau, mi_sps);
%subplot(312); plot(t, y); xlim([0 1000]); grid on;
%hold on; 
%subplot(312); plot(t(instants5), y(instants5), 'ro'); xlim([0 1000]);
%title('Sincronizador Early-Late - Simbolos decididos')

%%figure(5)
%instants6 = early_late_nda (y, sps_, amostras, mi_tau, mi_sps);
%subplot(313); plot(t, y); xlim([0 1000]); grid on;
%hold on; 
%subplot(313); plot(t(instants6), y(instants6), 'ro'); xlim([0 1000]);
%title('Sincronizador Early-Late - NDA')

%Chamada do sincronizador Gardner
instants2 = gardner(y, sps_, mi_tau, mi_sps);
figure(4)
subplot(211);
plot(t, y); xlim([0 1000]); grid on;
hold on;
subplot(211);
plot(t(instants2), y(instants2), 'ro'); xlim([0 1000]);
title('Sincronizador Gardner')

instants4 = gardner_decided(y, sps_, mi_tau, mi_sps);
subplot(212);
plot(t, y); xlim([0 1000]); grid on;
hold on;
subplot(212);
plot(t(instants4), y(instants4), 'ro'); xlim([0 1000]);
title('Sincronizador Gardner - Simbolos decididos')

%Chamada do sincronizador Mueller & Muller
figure(5)
instants3 = mueller_and_mueller(y, sps_, mi_tau, mi_sps);
plot(t, y); xlim([0 1000]); grid on;
hold on;
plot(t(instants3), y(instants3), 'ro'); xlim([0 1000]);