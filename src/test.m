# IMPORTANT: TEST IS NOT READY TO BE PUTTING IN USE


# Mi = beta e Tau = alpha
syms damp;
syms bw;
syms alpha;
syms beta;

beta = 4*damp*bw / (1+2*damp*bw + bw*bw)
alpha = 4*bw*bw / (1+2*damp*bw + bw*bw)

damp = (beta+ beta*bw*bw) / (4*bw - 2*beta*bw);
bw = (sqrt( -(alpha^2) + 4*alpha + alpha*alpha*damp) - alpha*damp) / (alpha - 4);
