%4-QAM
%Passo 1 - inicaliza��es
M = 4;    %Modula��o
SNR = -3:10;
k = log2(M);   %Bits por s�mbolo

%Passo 2 - Gera��o de 10^7 bits
g = randi([0,1], 10^7, 1);



