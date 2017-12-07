%4-QAM
clear
%Passo 1 - Inicalizações
M = [4 16 64];    %Parâmetros da Modulação
SNR = (-3:10);
berEstimada = zeros(size(SNR));

%Passo 2 - Geração de 10^7 bits
g = randi([0 1], 10^7, 1);

%Passo 3 - Cálculo da BER
for m = 1:length(M)
    fprintf('Para M = %d\n', M(m))
    k = log2(M(m));  %Bits por símbolo
    
    %Passo 3.1  - Cálculo de Eb/No
    EbN0 = SNR - 10*log10(k);

    %Passo 3.2 - Divisão em k bits/símbolo
    gSimbolo = reshape(g(1:length(g) - mod(length(g),k)), (length(g) - mod(length(g),k))/k, k);

    %Passo 3.3 - Transforma o sinal de binário para inteiro decimal
    sinTransmInt = bi2de(gSimbolo);
        
    %Passo 3.4 - Faz a modulação M-QAM binária
    %qammod acieta como parâmetros o sinal, tamanho da modulação e tipo
    %(binária ou Gray scale)
    modSin = qammod(sinTransmInt, M(m), 'bin');
    
    transmSin = 0;
    
    %Passo 3.5 - Transmissão pelo canal AWGN
    for n = 1:length(SNR)            
        %Passo 3.5.1 - Faz a transmissão por um canal AWGN com SNR especi-
        %ficada - 'measured' mede a potência do sinal antes de adicionar
        %o ruído
        %awgn - aceita como parâmetros o sinal, a SNR e 'measured'
        %explicado acima
        transmSin = awgn(modSin, SNR(n), 'measured');

        %Passo 3.5.2 - Faz a recepção e demodulação do sinal
        %qamdemod - aceita como parâmetros o sinal recebido, o tamanho
        %da demodulação e o tipo(binária ou Gray scale)
        recSin = qamdemod(transmSin, M(m), 'bin');

        %Passo 3.5.3 - Transforma o sinal de inteiro decimal em binário
        sinRecBin = de2bi(recSin, k);

        %Passo 3.5.4 - Calcula a BER propriamente dita
        %biterr - aceita como parâmetros duas matrizes a serem comparadas,
        %elemento a elemento, retornando o número de bits discordantes e
        %a razão entre os discordantes e o total de bits
        [errosTransmissao, erros] = biterr(gSimbolo, sinRecBin);

        %Passo 3.5.5 - Atualiza os valores de erro e bits transmitidos
        berEstimada(n) = erros; 

        fprintf('\tSNR = %d     BER = %d\n', SNR(n), berEstimada(n))
        
    end    
    %Passo 4 - Cálculo da BER teórica
    %berawgn - retorna a curva teórica de BER de vários esquemas de 
    %modulação.  Recebe como parâmetros Eb/N0, o tipo de modulação e 
    %o tamanho da modulação
    berTeorica = berawgn(EbN0,'qam',M(m));
    
    %Passo 5 - Plotagem de gráficos
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
        title('Gráfico BER/SNR')
        
end
 











