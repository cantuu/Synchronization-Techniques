clear all; close all; clc;

% Parametros
N = 1000;
sps = 40; sps_ = sps * 1;

Rs = 1.0;
Fa = Rs*sps;
t = (0: N*sps-1)/Fa;

amostras_el = 3;
tau = 0; mi = 0;
M = 2; %Modulation Order
k = log2(M); %Number of bits per symbol;

Eb_N0 = 0:6;
Eb_N0_lin = 10.^(Eb_N0/10);

a = 10;
erros_el = zeros(a,length(Eb_N0)); erros_el_dec = zeros(a,length(Eb_N0)); erros_el_nda = zeros(a,length(Eb_N0));
erros_gard = zeros(a,length(Eb_N0)); erros_gard_dec = zeros(a,length(Eb_N0));
erros_mm = zeros(a,length(Eb_N0)); theorical = zeros(a, length(Eb_N0));
for aux = 1:a
  aux 
  fflush(stdout);
  for i = 1:length(Eb_N0)
    bits = randi([0 1], 1, N);
    y = tx_chan(bits, N, sps, Eb_N0(i), 0);
    
    %%%% Analise Quantidade Erros %%%%
%    instants = early_late(y, sps_, amostras_el, tau, mi);
%    erros_el(aux, i) = comp(bits, y, instants);
%   
%    instants1 = early_late_decided(y, sps_, amostras_el, tau, mi);
%    erros_el_dec(aux, i) = comp(bits, y, instants1);
%    
%    instants2 = early_late_nda(y, sps_, amostras_el, tau, mi);
%    erros_el_nda(aux, i) = comp(bits, y, instants2);   
%    
%    instants3 = gardner(y, sps_, tau, mi);
%    erros_gard(aux, i) = comp(bits, y, instants3);
%    
%    instants4 = gardner_decided(y, sps_, tau, mi);
%    erros_gard_dec(aux, i) = comp(bits, y, instants4);
%    
    instants5 = mueller_and_mueller(y, sps_, tau, mi);
    erros_mm(aux, i) = comp(bits, y, instants5);
    
  end
end

%erros_el_mean = mean(erros_el);
%erros_el_mean_d = mean(erros_el_dec);
%erros_el_mean_n = mean(erros_el_nda);
%erros_gard_mean = mean(erros_gard);
%erros_gard_mean_d = mean(erros_gard_dec);
erros_mm_mean = mean(erros_mm);
%theorical_mean = mean(theorical);

theorical = qfunc(sqrt(2*Eb_N0_lin));


%subplot(131)
%semilogy(Eb_N0, erros_el_mean/length(bits), 'b'); hold on;
%semilogy(Eb_N0, erros_el_mean_d/length(bits), 'r');
%semilogy(Eb_N0, erros_el_mean_n/length(bits), 'g'); 
semilogy(Eb_N0, theorical, 'm'); %ylim([10^-7 1]);
 hold on; 
%legend('Early-Late', 'Early-Late Decided', 'Early-Late NDA');
%
%subplot(132)
%semilogy(Eb_N0, erros_gard_mean/length(bits), 'b'); hold on;
%semilogy(Eb_N0, erros_gard_mean_d/length(bits), 'r');
%legend('Gardner', 'Gardner Decided')
%
%subplot(133)
semilogy(Eb_N0, erros_mm_mean/length(bits)) 
%legend('Muller & Mueller')