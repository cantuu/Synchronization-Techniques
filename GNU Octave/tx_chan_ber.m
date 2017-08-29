function out = tx_chan_ber(bits , N, sps, SNR, delta)

%Trem de impulsos - Filtro
Hs = ones(1,sps);
Hr = fliplr(Hs);

%Geração sequencia bits
x = 2*bits -1;

%Interpolaçao            
up = upsample (x, sps);
s = conv(Hs, up);
s = s(1:N*sps);

s_atrasado = [zeros(1, delta) s];
s_atrasado = s_atrasado(1:N*sps);

%Canal AWGN e Filtro Casado(Impulso)
r1 = awgn(s_atrasado, SNR, 'measured');
y1 = (conv(r1, Hr))/sps;
out = y1(1:N*sps);

end