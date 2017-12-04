clc;
clear;

%Definição de parâmetros
SNR = -3:1:10;
M = 4;     %Tamanho da constelação
k = log2(M);    %Número de bits por símbolo 

%ETAPA 1:
%Gere uma fonte de informação g que produz 10?7 bits 1s e 0s com igual probabilidade.
g = randi([0,1],10^7,1);

%Exemplo da amostra
%stem(g(1:20), 'filled');
%title('Amostra aleatória');
%ylabel('Valor binário');
%xlabel('Amostra');

%ETAPA 2:
%Utilize g para gerar o vetor de amostras x moduladas em banda passante no
%formato QAM. Aqui, note que M = 2 representa o tamanho da constelação.
qamData = reshape(g, length(g)/k, k);  %Agrupa os dados de acordo com
                                        %o número de bits por símbolo
gInt = bi2de(qamData);  %Converte de binário para inteiro

%Exemplo da amostra em decimal
stem(gInt(1:20), 'filled');
title('Amostra aleatória');
ylabel('Valor inteiro');
xlabel('Amostra');

%ETAPA 3:
%Gere um vetor de amostras de um processo ruidoso gaussiano branco.
ruido = awgn(gInt, SNR(1));

