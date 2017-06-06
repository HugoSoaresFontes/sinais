function resposta=reverter(vetor)
    comprimento = length(vetor)
    resposta = zeros(1,comprimento);
    for i = 0:comprimento-1
        resposta(i+1) = vetor(comprimento-i);
    end
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
//                           1 2 3 4 5 6 7
//                             3 4 5 8 7 6 4
function resposta=convolucao(vetor1,vetor2)
    comprimento1 = length(vetor1)
    comprimento2 = length(vetor2)
    comprimento = comprimento1 + comprimento2
    soma = 0
    resposta = zeros(1, comprimento)
    vetor2Invertido = reverter(v2);
    for i = 1:comprimento/2
        for j = 1:i
            if j <= comprimento1 then
                if j<= comprimento2 then
                    soma = soma + (vetor1(j)*vetor2Invertido(comprimento2+j-i))
                end
            end
        end
        resposta(1,i) = soma
        soma = 0
    end
endfunction

clf();
titlepage("Q1 e Q2 - Expansão e interpolação de sinais ");
sleep(2500);
clf();

fator = 3
nucleo = [1 1 1]
s1 = [1 0 2 3 4 5 6 7 6 5 4 2 1 3 4 5];
t1 = 0:length(s1)-1; 

subplot(131);
title("Sinal incial");
xlabel("Tempo");
ylabel("y(tempo)");
plot2d3(t1,s1);
plot(t1,s1, '.');
sleep(1000);

subplot(132);
s2 = expansao(s1, fator);
t2 = 0:length(s2)-1;
title("Sinal expandido com fator: " + string(fator));
xlabel("Tempo");
ylabel("y(tempo)");    
plot2d3(t2,s2);
plot(t2,s2, 'r.');

sleep(1000);

subplot(133);
aproximado = interpolar(s2, nucleo);
title("Sinal expandido (com fator " + string(fator) + ") interpolado");
xlabel("Tempo");
ylabel("y(tempo)");
plot2d3(t2,aproximado);
plot(t2,aproximado, 'r.');

sleep(5000);

clf();
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



