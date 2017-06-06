function resposta=reverter(vetor)
    comprimento = length(vetor)
    resposta = zeros(1,comprimento);
    for i = 0:comprimento-1
        resposta(i+1) = vetor(comprimento-i);
    end
endfunction

function resposta=convolucao(x, y)
    resposta = zeros(1,length(x) + length(y) - 1);
    matriz = zeros(length(x), 2*length(y))
    for linha = 1:length(x)
        for coluna = 1:length(y)
            matriz(linha, coluna+linha-1) = y(1,coluna)
        end
    end
    resposta = x * matriz;
endfunction

function resposta=getKernel(fator, tipo)
    if tipo == "t"  then
        nucleo = zeros(1, 2*fator+1)
        denominador = 1/fator
        for i = 0:fator+1
            nucleo(1,i+1) = i * denominador 
        end
        for i = 1:fator
            nucleo(1,length(nucleo)+1-i) = nucleo(1,i) 
        end
    end
    resposta = nucleo
endfunction

function resposta=expansao(vetor, fator)
    comprimento = length(vetor);
    resposta = zeros(1, fator*comprimento);
    resposta(1,1) = vetor(1,1);
    for i= 1:length(vetor)-1
        resposta(1,(fator*i+1)) = vetor(1,i+1);
    end
endfunction

function resposta=interpolar(vetor, nucleo)
    limite = round(((length(nucleo)-0.1))/2)
    resposta = vetor
    convolucao = conv(vetor, nucleo);
    resposta = convolucao(limite+1:length(convolucao)-limite);
endfunction


clf();
titlepage("Expansão e interpolação de sinais ");
sleep(1500);
clf();

// Questao 1
s1 = [9 4 6 7 8 6 5 2 3 4 5 2 3 4 1 3 4]
t1 = 0:length(s1)-1
s2 = [7 4 6 2 1 2 4 5]
t2 = 0:length(s2)-1
con = convolucao(s1,s2)
tt = 0:length(con)-1

subplot(231);
title("Sinal 1");
xlabel("Tempo");
ylabel("y(tempo)");    
plot(t1, s1, '--ob');


subplot(232);
title("Sinal 1");
xlabel("Tempo");
ylabel("y(tempo)");    
plot(t2, s2, '--og');

subplot(233);
title("S1 * S2");
xlabel("Tempo");
ylabel("y(tempo)");    
plot(tt, con, '--or');

// Questoes 2 e 3
fator = 3
nucleo = getKernel(3, "t")
s1 = [1 0 2 3 4 5 6 7 6 5 4 2 1 3 4 5];
t1 = 0:length(s1)-1; 


subplot(234);
title("Sinal incial");
xlabel("Tempo");
ylabel("y(tempo)");
plot2d3(t1,s1);
plot(t1,s1, '.');
sleep(1000);

subplot(235);
s2 = expansao(s1, fator);
t2 = 0:length(s2)-1;
title("Sinal expandido com fator: " + string(fator));
xlabel("Tempo");
ylabel("y(tempo)");    
plot2d3(t2,s2);
plot(t2,s2, 'g.');

sleep(1000);

subplot(236)
title("Sinal expandido (com fator " + string(fator) + ") Interopolado");
xlabel("Tempo");
ylabel("y(tempo)");
plot(t2(1), s2(1,1), 'b.');    
for i = 2:length(t2)
    if modulo(i-1,fator) == 0 then
        plot2d3(t2(i), s2(1,i));
        plot(t2(i), s2(1,i), 'b.');   
        sleep(100);             
    end
end
for i = 2:(length(t2)-fator+1)
    if modulo(i-1,fator) > 0 then
        plot2d3(t2(i), aproximado(1,i));
        plot(t2(i), aproximado(1,i), 'r.');  
        sleep(100);                           
    end
end



