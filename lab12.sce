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
    nucleo = zeros(1, 2*fator+1)
    if tipo == "t"  then
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

function resposta=compressao(vetor, fator)
    comprimento = length(vetor);
    resposta = zeros(1, comprimento/fator);
    disp(fator)
    for i= 0:round(length(vetor)/fator)-1
        resposta(1,i+1) = vetor(1,(fator*i+1));
    end
endfunction

function resposta=interpolar(vetor, nucleo)
    limite = round(((length(nucleo)-0.1))/2)
    resposta = vetor
    convolucao = conv(vetor, nucleo);
    resposta = convolucao(limite+1:length(convolucao)-limite);
endfunction


clf();
titlepage("Decimação, Expansão e interpolação de sinais ");
sleep(1500);
clf();

// Questao 1
s1 = [9 4 6 7 8 6 5 2 3 4 5 2 3 4 1 3 4]
t1 = 0:length(s1)-1
s2 = [7 4 6 2 1 2 4 5]
t2 = 0:length(s2)-1
con = convolucao(s1,s2)
tt = 0:length(con)-1

//Sinal 1
subplot(331);
title("Sinal 1");
xlabel("t");
ylabel("y(t)");    
plot(t1, s1, '--ob');
sleep(1000);

//Sinal 2
subplot(332);
title("Sinal 1");
xlabel("t");
ylabel("y(t)");    
plot(t2, s2, '--og');
sleep(1000);

// Convolucao S1 * S2
subplot(333);
title("S1 * S2");
xlabel("t");
ylabel("y(t)");    
plot(tt, con, '--or');
sleep(1000);



// Questoes 2, 3 e 4
fator = 3
nucleo = getKernel(fator, "t")
s = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31];
t = 0:length(s)-1; 

// Sinal Inicial
subplot(334);
title("Sinal incial");
xlabel("t");
ylabel("y(t)");
plot2d3(t,s);
plot(t,s, '-b.');
sleep(1000);

// Sinal comprimido pelo fator
subplot(335);
scomprimido = compressao(s, fator);
tcomprimido = 0:length(scomprimido)-1;
tcomprimido = 0:1*fator:length(s)-1*fator
title("Sinal comprimido com fator: " + string(fator));
xlabel("t");
ylabel("y(t)");    
plot2d3(tcomprimido,scomprimido);
plot(tcomprimido,scomprimido, '-g.');
sleep(1000);

// Expansao do sinal anteriormento comprimido pelo mesmo fator
subplot(336);
sExpandido = expansao(scomprimido, fator);
tExpandido = 0:1/fator:length(sExpandido);
tExpandido = 0:1:tcomprimido(length(tcomprimido))+fator-1
title("Sinal expandido com fator: " + string(fator));
xlabel("t");
ylabel("y(t)");    
plot2d3(tExpandido,sExpandido);
plot(tExpandido,sExpandido, 'r.');
sleep(1000);

// Interporlação pela convolucacao do sinal expandido com o nucleo
aproximado = interpolar(sExpandido, nucleo);
subplot(337)
title("Sinal expandido (com fator " + string(fator) + ") Interopolado");
xlabel("t");
ylabel("y(t)");
plot(tExpandido(1), sExpandido(1,1), 'b.');    
for i = 2:length(tExpandido)
    if modulo(i-1,fator) == 0 then
        plot2d3(tExpandido(i), sExpandido(1,i));
        plot(tExpandido(i), sExpandido(1,i), '-b.');   
        sleep(100);             
    end
end
for i = 2:(length(tExpandido))-fator+1
    if modulo(i-1,fator) > 0 then
        plot2d3(tExpandido(i), aproximado(1,i));
        plot(tExpandido(i), aproximado(1,i), 'r.');  
        sleep(100);                           
    end
end
plot(tExpandido(1:length(tExpandido)-fator+1), aproximado(1:length(tExpandido)-fator+1), '-b');    
tprov = tExpandido(1:length(tExpandido)-fator+1)  


