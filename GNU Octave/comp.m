function erro = comp(bits, y, instants)

    y_hat = y(instants) > 0;
    n = length(instants) - length(bits);
    if(length(bits) > length(instants))
       bits = bits(1:length(instants));
    else
       bits = [bits randi([0 1], 1, n)];  
    endif
    %bits = circshift(bits', 5)';
    erro = sum(xor(bits,y_hat));

end