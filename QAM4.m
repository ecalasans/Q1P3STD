%4-QAM
%Passo 1 - inicalizações
M = 4;    %Modulação
SNR = -3:10;
k = log2(M);   %Bits por símbolo

%Passo 2 - Geração de 10^7 bits
g = randi([0,1], 10^7, 1);



