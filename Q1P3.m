clc;
clear;

%Defini��o de par�metros
SNR = -3:1:10;
M = 4;     %Tamanho da constela��o
k = log2(M);    %N�mero de bits por s�mbolo 

%ETAPA 1:
%Gere uma fonte de informa��o g que produz 10?7 bits 1s e 0s com igual probabilidade.
g = randi([0,1],10^7,1);

%Exemplo da amostra
%stem(g(1:20), 'filled');
%title('Amostra aleat�ria');
%ylabel('Valor bin�rio');
%xlabel('Amostra');

%ETAPA 2:
%Utilize g para gerar o vetor de amostras x moduladas em banda passante no
%formato QAM. Aqui, note que M = 2 representa o tamanho da constela��o.
qamData = reshape(g, length(g)/k, k);  %Agrupa os dados de acordo com
                                        %o n�mero de bits por s�mbolo
gInt = bi2de(qamData);  %Converte de bin�rio para inteiro

%Exemplo da amostra em decimal
stem(gInt(1:20), 'filled');
title('Amostra aleat�ria');
ylabel('Valor inteiro');
xlabel('Amostra');

%ETAPA 3:
%Gere um vetor de amostras de um processo ruidoso gaussiano branco.
ruido = awgn(gInt, SNR(1));

