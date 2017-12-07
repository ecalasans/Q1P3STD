%4-QAM
clear
%Passo 1 - inicaliza��es
M = 16;    %Modula��o
SNR = (-3:10)';
k = log2(M); %Bits por s�mbolo
berEstimada = zeros(size(SNR));

%Passo 2 - Gera��o de 10^7 bits
g = randi([0,1], 10^7, 1);

%Passo 3 - C�lculo de Eb/No
EbN0 = SNR - 10*log10(k);

%Passo 5 - Divis�o em k bits/s�mbolo
gSimbolo = reshape(g, length(g)/k, k);

%Passo 6 - Transforma o sinal em inteiro
sinTransmInt = bi2de(gSimbolo);
        
 %Passo 7 - Faz a modula��o QAM bin�ria
 modSin = qammod(sinTransmInt, M, 'bin');

%Passo 8 - C�lculo da BER
for n = 1:length(EbN0)            
    %Passo 8.1 - Faz a transmiss�o por um canal AWGN com SNR especi-
    %ficada - 'measured' mede a pot�ncia do sinal antes de adicionar
    %o ru�do
    transmSin = awgn(modSin, SNR(n), 'measured');
        
    %Passo 8.2 - Faz a demodula��o do sinal
    recSin = qamdemod(transmSin, M, 'bin');
        
    %Passo 8.3 - Transforma o sinal em bin�rio
    sinRecBin = de2bi(recSin, k);
        
    %Passo 6.5 - Calcula o n�mero de bits errados
    [errosTransmissao, erros] = biterr(gSimbolo, sinRecBin);
        
    %Passo 6.6 - Atualiza os valores de erro e bits transmitidos
    berEstimada(n) = erros; 
    
    fprintf('SNR = %d     BER = %d\n', SNR(n), berEstimada(n))
end
    


%Passo 7 - C�lculo da BER te�rica
berTeorica = berawgn(EbN0,'qam',M);

%Passo 8 - Plotagem dos gr�ficos
    %Passo 8.1 - Curva BER/EbN0
    semilogy(EbN0, berTeorica, 'r')
    xlim([-3 10])
    grid
    hold on
    semilogy(EbN0, berEstimada, '*')
    legend('BER te�rica', 'BER estimada')
    xlabel('Eb/N0 em dB')
    ylabel('Probabilidade de Erro de Bit(BER)')






