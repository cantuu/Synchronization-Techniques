clear all; close all; clc;

#Parametros
N = 1000;
sps = 40;
sps_ = sps * 1.01;
Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;
snr_db = 20;
amostras_el = 3;
samples = 5;
tau = 1;
mi = 0.5;

disp('Select what kind of analysis you want:');
disp('[1] - Convergency Speed / SNR');
disp('[2] - Convergency Speed / Samples Early-Late')
disp('[3] - Convergency Speed / MI Variation')
disp('[4] - Convergency Speed / TAU Variation')
prompt = ''; 
option = input(prompt);

if (option == 1)  
  %%%% Analise Convergencia/SNR %%%%
  SNR = [0:30];
  a = 5; 
  conv_el = zeros(a,length(SNR)); conv_el_dec = zeros(a,length(SNR)); 
  conv_el_nda = zeros(a,length(SNR)); conv_mm = zeros(a,length(SNR));
  conv_g = zeros(a,length(SNR)); conv_g_d = zeros(a,length(SNR));

  for j = 1:a  
    for i = 1:length(SNR)
        bits = randi([0 1], 1, N);
        y1 = tx_chan(bits, N, sps, SNR(i), 0);     
        
        instants1 = early_late(y1, sps_, amostras_el, tau, mi);
        conv_el(j,i) = convergencia(y1, instants1, samples, sps);
        
        instants2 = early_late_decided(y1, sps_, amostras_el, tau, mi);
        conv_el_dec(j,i) = convergencia(y1, instants2, samples, sps);
        
        instants3 = early_late_nda(y1, sps_, amostras_el, tau, mi);
        conv_el_nda(j,i) = convergencia(y1, instants3, samples, sps);
        
        instants4 = mueller_and_mueller(y1, sps_, tau, mi);
        conv_mm(j,i) = convergencia(y1, instants4, samples, sps);
        
        instants5 = gardner(y1, sps_, tau, mi);
        conv_g(j,i) = convergencia(y1, instants5, samples, sps);
        
        instants6 = gardner(y1, sps_, tau, mi);
        conv_g_d(j,i) = convergencia(y1, instants6, samples, sps);
    end
  end
  conv_el_avg = mean(conv_el);
  conv_el_dec_avg = mean(conv_el_dec);
  conv_el_nda_avg = mean(conv_el_nda);
  conv_mm_avg = mean(conv_mm);
  conv_g_avg = mean(conv_g);
  conv_g_d_avg = mean(conv_g_d);

  figure(1); 
  subplot(131)
  plot(SNR, conv_el_avg, 'b'); hold on;
  plot(SNR, conv_el_dec_avg, 'r'); 
  plot(SNR, conv_el_nda_avg, 'g'); %hold off;
  legend('Early-Late', 'Early-Late Decided', 'Early-Late NDA');

  subplot(132) ;
  plot(SNR, conv_mm_avg, 'r');
  legend('Muller & Muller');

  subplot(133)
  plot(SNR, conv_g_avg, 'g'); hold on; 
  plot(SNR, conv_g_d_avg, 'r'); hold off
  legend('Gardner', 'Gardner Decided')

elseif(option == 2)
  %%% Analise Samples Early-Late %%%%
  samp = [1:35];
  snr_el = 100;
  a1 = 5;
  conv_el1 = zeros(a1,length(samp)); conv_el_dec1 = zeros(a1,length(samp)); 
  conv_el_nda1 = zeros(a1,length(samp));
  
  for j = 1:a1
    for i = 1:length(samp)
       bits = randi([0 1], 1, N);
       y_el = tx_chan(bits, N, sps, snr_el, 0);     
        
       instants1 = early_late(y_el, sps_, samp(i), tau, mi);
       conv_el1(j,i) = convergencia(y_el, instants1, samples, sps);
       
       instants2 = early_late_decided(y_el, sps_, samp(i), tau, mi);
       conv_el1_dec(j,i) = convergencia(y_el, instants2, samples, sps);
       
       instants3 = early_late_nda(y_el, sps_, samp(i), tau, mi);
       conv_el1_nda(j,i) = convergencia(y_el, instants3, samples, sps);    
    end
  end
  conv_el1_avg = mean(conv_el1);
  conv_el1_dec_avg = mean(conv_el1_dec);
  conv_el1_nda_avg = mean(conv_el1_nda);

  figure(2); title('Variaçao numero amostas Early-Late com SNR Fixa');
  subplot(131); plot(samp, conv_el1_avg); legend('Early-Late');
  subplot(132); plot(samp, conv_el1_dec_avg); axis([1 length(samp) 0 1000]); legend('Early-Late Decided');
  subplot(133); plot(samp, conv_el1_nda_avg); legend('Early-Late NDA');

elseif(option == 3)
  %%%% Analise Velocidade Convergencia Variando TAU %%%%%%
  snr_db = 100;
  a2 = 5;
  tau_test = [0:0.1:5];
  tau_el = zeros(a2,length(tau_test)); tau_el_dec = zeros(a2,length(tau_test)); 
  tau_el_nda = zeros(a2,length(tau_test)); tau_gard = zeros(a2,length(tau_test)); 
  tau_gard_dec = zeros(a2,length(tau_test)); tau_mm = zeros(a2,length(tau_test));

  for j = 1:a2
     for i = 1:length(tau_test)
        bits = randi([0 1], 1, N);
        y_tau = tx_chan(bits, N, sps, snr_db, 0);    
        
        instants1 = early_late(y_tau, sps_, amostras_el, tau_test(i), mi);
        tau_el(j,i) = convergencia(y_tau, instants1, samples, sps);
        
        instants2 = early_late_decided(y_tau, sps_, amostras_el, tau_test(i), mi);
        tau_el_dec(j,i) = convergencia(y_tau, instants2, samples, sps);
        
        instants3 = early_late_nda(y_tau, sps_, amostras_el, tau_test(i), mi);
        tau_el_nda(j,i) = convergencia(y_tau, instants3, samples, sps);
        
        instants4 = mueller_and_mueller(y_tau, sps_, tau_test(i), mi);
        tau_mm(j,i) = convergencia(y_tau, instants4, samples, sps);
        
        instants5 = gardner(y_tau, sps_, tau_test(i), mi);
        tau_gard(j,i) = convergencia(y_tau, instants5, samples, sps);
        
        instants6 = gardner(y_tau, sps_, tau_test(i), mi);
        tau_gard_dec(j,i) = convergencia(y_tau, instants6, samples, sps);
    end
  end
  tau_el_avg = mean(tau_el);
  tau_el_dec_avg = mean(tau_el_dec);
  tau_el_nda_avg = mean(tau_el_nda);
  tau_mm_avg = mean(tau_mm);
  tau_g_avg = mean(tau_gard);
  tau_g_d_avg = mean(tau_gard_dec);

  figure(3); 
  subplot(131)
  plot(tau_test, tau_el_avg, 'b'); hold on;
  plot(tau_test, tau_el_dec_avg, 'r'); 
  plot(tau_test, tau_el_nda_avg, 'g'); %hold off;
  legend('Early-Late', 'Early-Late Decided', 'Early-Late NDA');

  subplot(132) ;
  plot(tau_test, tau_mm_avg, 'r');
  legend('Muller & Muller');

  subplot(133)
  plot(tau_test, tau_g_avg, 'g'); hold on; 
  plot(tau_test, tau_g_d_avg, 'r'); hold off
  legend('Gardner', 'Gardner Decided')

elseif(option == 4)
  %%%% Analise Velocidade Convergencia Variando MI %%%%
  snr_db = 100;
  a3 = 5;
  mi_test = [0:0.05:1];
  mi_el = zeros(a3,length(mi_test)); mi_el_dec = zeros(a3,length(mi_test)); 
  mi_el_nda = zeros(a3,length(mi_test)); mi_gard = zeros(a3,length(mi_test)); 
  mi_gard_dec = zeros(a3,length(mi_test)); mi_mm = zeros(a3,length(mi_test));

  for j = 1:a3
     for i = 1:length(mi_test)
        bits = randi([0 1], 1, N);
        y_mi = tx_chan(bits, N, sps, snr_db, 0);      
        
        instants1 = early_late(y_mi, sps_, amostras_el, tau, mi_test(i));
        mi_el(j,i) = convergencia(y_mi, instants1, samples, sps);
        
        instants2 = early_late_decided(y_mi, sps_, amostras_el, tau, mi_test(i));
        mi_el_dec(j,i) = convergencia(y_mi, instants2, samples, sps);
        
        instants3 = early_late_nda(y_mi, sps_, amostras_el, tau, mi_test(i));
        mi_el_nda(j,i) = convergencia(y_mi, instants3, samples, sps);
        
        instants4 = mueller_and_mueller(y_mi, sps_, tau, mi_test(i));
        mi_mm(j,i) = convergencia(y_mi, instants4, samples, sps);
        
        instants5 = gardner(y_mi, sps_, tau, mi_test(i));
        mi_gard(j,i) = convergencia(y_mi, instants5, samples, sps);
        
        instants6 = gardner(y_mi, sps_, tau, mi_test(i));
        mi_gard_dec(j,i) = convergencia(y_mi, instants6, samples, sps);
    end
  end
  mi_el_avg = mean(mi_el);
  mi_el_dec_avg = mean(mi_el_dec);
  mi_el_nda_avg = mean(mi_el_nda);
  mi_mm_avg = mean(mi_mm);
  mi_g_avg = mean(mi_gard);
  mi_g_d_avg = mean(mi_gard_dec);

  figure(4); 
  subplot(131)
  plot(mi_test, mi_el_avg, 'b'); hold on;
  plot(mi_test, mi_el_dec_avg, 'r'); 
  plot(mi_test, mi_el_nda_avg, 'g'); hold off;
  legend('Early-Late', 'Early-Late Decided', 'Early-Late NDA');

  subplot(132) ;
  plot(mi_test, mi_mm_avg, 'r');
  legend('Muller & Muller');

  subplot(133)
  plot(mi_test, mi_g_avg, 'g'); hold on;
  plot(mi_test, mi_g_d_avg, 'r'); 
  legend('Gardner', 'Gardner Decided')
  
else
  disp('Invalid Option!')  
endif  