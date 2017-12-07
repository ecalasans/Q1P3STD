%4-QAM
clear
%Passo 1 - Inicaliza��es
M = [4 16 64];    %Par�metros da Modula��o
SNR = (-3:10);
berEstimada = zeros(size(SNR));

%Passo 2 - Gera��o de 10^7 bits
g = randi([0 1], 10^7, 1);

%Passo 3 - C�lculo da BER
for m = 1:length(M)
    fprintf('Para M = %d\n', M(m))
    k = log2(M(m));  %Bits por s�mbolo
    
    %Passo 3.1  - C�lculo de Eb/No
    EbN0 = SNR - 10*log10(k);

    %Passo 3.2 - Divis�o em k bits/s�mbolo
    gSimbolo = reshape(g(1:length(g) - mod(length(g),k)), (length(g) - mod(length(g),k))/k, k);

    %Passo 3.3 - Transforma o sinal de bin�rio para inteiro decimal
    sinTransmInt = bi2de(gSimbolo);
        
    %Passo 3.4 - Faz a modula��o M-QAM bin�ria
    %qammod acieta como par�metros o sinal, tamanho da modula��o e tipo
    %(bin�ria ou Gray scale)
    modSin = qammod(sinTransmInt, M(m), 'bin');
    
    transmSin = 0;
    
    %Passo 3.5 - Transmiss�o pelo canal AWGN
    for n = 1:length(SNR)            
        %Passo 3.5.1 - Faz a transmiss�o por um canal AWGN com SNR especi-
        %ficada - 'measured' mede a pot�ncia do sinal antes de adicionar
        %o ru�do
        %awgn - aceita como par�metros o sinal, a SNR e 'measured'
        %explicado acima
        transmSin = awgn(modSin, SNR(n), 'measured');

        %Passo 3.5.2 - Faz a recep��o e demodula��o do sinal
        %qamdemod - aceita como par�metros o sinal recebido, o tamanho
        %da demodula��o e o tipo(bin�ria ou Gray scale)
        recSin = qamdemod(transmSin, M(m), 'bin');

        %Passo 3.5.3 - Transforma o sinal de inteiro decimal em bin�rio
        sinRecBin = de2bi(recSin, k);

        %Passo 3.5.4 - Calcula a BER propriamente dita
        %biterr - aceita como par�metros duas matrizes a serem comparadas,
        %elemento a elemento, retornando o n�mero de bits discordantes e
        %a raz�o entre os discordantes e o total de bits
        [errosTransmissao, erros] = biterr(gSimbolo, sinRecBin);

        %Passo 3.5.5 - Atualiza os valores de erro e bits transmitidos
        berEstimada(n) = erros; 

        fprintf('\tSNR = %d     BER = %d\n', SNR(n), berEstimada(n))
        
    end    
    %Passo 4 - C�lculo da BER te�rica
    %berawgn - retorna a curva te�rica de BER de v�rios esquemas de 
    %modula��o.  Recebe como par�metros Eb/N0, o tipo de modula��o e 
    %o tamanho da modula��o
    berTeorica = berawgn(EbN0,'qam',M(m));
    
    %Passo 5 - Plotagem de gr�ficos
        %Passo 5.1 - Curva BER SNR
        semilogy(SNR, berTeorica)
        xlim([-3 10])
        grid
        hold on
        semilogy(SNR, berEstimada, '*')
        hold on
        legend('4-QAM', 'BER estimada 4-QAM', '16-QAM','BER estimada 16-QAM', '64-QAM', 'BER estimada 64-QAM','Location', 'southeast')
        xlabel('SNR em dB')
        ylabel('Probabilidade de Erro de Bit(BER)')
        title('Gr�fico BER/SNR')
        
end
 











