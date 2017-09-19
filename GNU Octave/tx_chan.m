function out = tx_chan(bits , N, sps, Eb_N0, delta)

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

Eb_N0_lin = 10.^(Eb_N0/10);

Eb = sum(abs(s).^2) / length(bits);
N0 = Eb/Eb_N0_lin;

w = randn(size(s_atrasado)) * sqrt(N0/2);
r1 = s_atrasado + w;

%Canal AWGN e Filtro Casado(Impulso)
%r1 = awgn(s_atrasado, Eb_N0, 'measured');
y1 = (conv(r1, Hr))/sps;
out = y1(1:N*sps);

end