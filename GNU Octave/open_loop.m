function instants = open_loop(y, Fa, Rs);
Ly = length(y);
N = 1000;
F = ((-Ly/2 : Ly/2 - 1) / Ly)*Fa;
sps = Fa/Rs;
ysq = y.^2;
YSQ = fftshift(fft(ysq));
atraso = (400/2) + 1;

%Projeto do filtro e processo de filtragem;
b = fir1 (400, [0.9*Rs 1.1*Rs]/(Fa/2));
ysq_filt = filter(b, 1, ysq);
Ysq_filt = fftshift(fft(ysq_filt));

%Desatraso do sinal
ysq_filt = ysq_filt(atraso:end);
ysq_filt = [ysq_filt zeros(1,atraso-1)];
ysq_filt = imag(hilbert(ysq_filt));

clk = sign(ysq_filt);

diferenca = diff(clk);
amostras = diferenca > 0;
instants = find(amostras>0);

end