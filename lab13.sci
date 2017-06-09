// Hugo Soares Eng. Eletrica 2016.1

stacksize('max')
chdir('/home/hugo/sinais');
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

function resposta=expansao(vetor, fator, canais)
    comprimento = length(vetor)/canais;
    resposta = zeros(canais, fator*comprimento);
    for canal = 1:canais
        resposta(canal,1) = vetor(canal,1)
    end
    resposta(1,1) = vetor(1,1);
    for i= 1:length(vetor)/canais-1
        for canal = 1:canais
            resposta(canal,(fator*i+1)) = vetor(canal,i+1);
        end
    end
endfunction

function resposta=compressao(vetor, fator, canais)
    comprimento = length(vetor)/canais;
    resposta = zeros(canais, comprimento/fator);
    for i= 0:round(length(vetor)/fator/canais)-1
        for canal = 1:canais
            resposta(canal,i+1) = vetor(canal,(fator*i+1));
        end
    end
endfunction

function resposta=interpolar(matriz, nucleo, canais)
    limite = round(((length(nucleo)-0.1))/2)
    resposta = matriz
    for canal = 1:canais
        convolucao = convol(matriz(canal,:), nucleo);    
        resposta(canal,:) = convolucao(limite+1:length(convolucao)-limite);
    end

endfunction

fator=2
[y,x] = loadwave('batera.wav');
subplot(411);
title("Áudio Original");
xlabel("t");
ylabel("y(t)");  
//plot2d3(y(1,:));
plot(y(1,:));
sound(y, x(3));

sleep(1000)

comprimido = compressao(y, fator, x(2))
subplot(412);
title("Audio comprimido por : " + string(fator));
xlabel("t");
ylabel("y(t)");    
axies=get("current_axes")
axies.data_bounds = [0,(length(y)/2),0,1]  
//plot2d3(comprimido(1,:));
plot(comprimido(1,:), 'r');

sleep(1000)

expandido = expansao(comprimido, fator, x(2))
subplot(413);
title("Audio comprimido sendo expandido por : " + string(fator));
xlabel("t");
ylabel("y(t)");    
//plot2d3(expandido(1,:));
plot(expandido(1,:), 'g');

sleep(1000)

nucleo = getKernel(fator, "t")
aproximado = interpolar(expandido, nucleo, x(2))
subplot(414);
title("Audio expandido interpolado");
xlabel("t");
ylabel("y(t)");    
//plot2d3(aproximado(1,:));
plot(aproximado(1,:));
sound(aproximado, x(3))

