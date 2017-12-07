%4-QAM
clear
%Passo 1 - inicalizações
M = 16;    %Modulação
SNR = (-3:10)';
k = log2(M); %Bits por símbolo
berEstimada = zeros(size(SNR));

%Passo 2 - Geração de 10^7 bits
g = randi([0,1], 10^7, 1);

%Passo 3 - Cálculo de Eb/No
EbN0 = SNR - 10*log10(k);

%Passo 5 - Divisão em k bits/símbolo
gSimbolo = reshape(g, length(g)/k, k);

%Passo 6 - Transforma o sinal em inteiro
sinTransmInt = bi2de(gSimbolo);
        
 %Passo 7 - Faz a modulação QAM binária
 modSin = qammod(sinTransmInt, M, 'bin');

%Passo 8 - Cálculo da BER
for n = 1:length(EbN0)            
    %Passo 8.1 - Faz a transmissão por um canal AWGN com SNR especi-
    %ficada - 'measured' mede a potência do sinal antes de adicionar
    %o ruído
    transmSin = awgn(modSin, SNR(n), 'measured');
        
    %Passo 8.2 - Faz a demodulação do sinal
    recSin = qamdemod(transmSin, M, 'bin');
        
    %Passo 8.3 - Transforma o sinal em binário
    sinRecBin = de2bi(recSin, k);
        
    %Passo 6.5 - Calcula o número de bits errados
    [errosTransmissao, erros] = biterr(gSimbolo, sinRecBin);
        
    %Passo 6.6 - Atualiza os valores de erro e bits transmitidos
    berEstimada(n) = erros; 
    
    fprintf('SNR = %d     BER = %d\n', SNR(n), berEstimada(n))
end
    


%Passo 7 - Cálculo da BER teórica
berTeorica = berawgn(EbN0,'qam',M);

%Passo 8 - Plotagem dos gráficos
    %Passo 8.1 - Curva BER/EbN0
    semilogy(EbN0, berTeorica, 'r')
    xlim([-3 10])
    grid
    hold on
    semilogy(EbN0, berEstimada, '*')
    legend('BER teórica', 'BER estimada')
    xlabel('Eb/N0 em dB')
    ylabel('Probabilidade de Erro de Bit(BER)')






