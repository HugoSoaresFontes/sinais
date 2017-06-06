//Hugo Soares Eng Elétrica 2016.1

//ODE
function ydot=funcao(t, y)
    ydot=1-y
endfunction

//Forward 
function ypos=forward(x, y,Tzao, tao)
    ypos = (Tzao/tao)*x+(1-Tzao/tao)*y
endfunction

//Backward
function y=backward(x, y_anterior,Tzao, tao)
    y = (x*(Tzao/tao)+y_anterior)/(1+Tzao/tao)
endfunction

// Setagem inicial 
y0=0;
t0=0;
tao = 1; 
x = 1;
tmax = 10; 
step = 1/800;
t=t0:step:tmax;

// Resultado através da ode
continua = ode(y0,t0,t,funcao);

//Count auxiliar utilzado para a plotagem dos gráficos de acordo com o Tzao
count_auxiliar = 0;
for count = 1:4
    //Setagem dos valores de Tzao
    if (count == 1)
        Tzao = 1/10;
    end
    if (count == 2)
        Tzao =  10/10;
        count_auxiliar = 1;
    end
    if (count == 3)
        Tzao =  15/10;
        count_auxiliar = 2;
    end
    if (count == 4)
        Tzao =  20/10;
        count_auxiliar = 3;
    end
    //comprimento dos vetores com as amostras de backward e forward. DeltaT/Tzao + o valor inicial
    comprimento = ((tmax-t0)/Tzao)+1;
    
    y_discreto_forward = zeros(1, comprimento);
    //Calcula-se o y posterior -[y(i+1)] com base no y atual [y(i)] através da função forward
    for i = 1:comprimento-1 
       y_discreto_forward(1,i+1) = forward(x,y_discreto_forward(i),Tzao,tao);
    end
    
    //Calcula-se o y atual [y(i)] com base no y anterior [y(i-1)] através da função forward
    y_discreto_backward = zeros(1, comprimento);
    for i = 2:comprimento 
       y_discreto_backward(1,i) = backward(x,y_discreto_backward(i-1),Tzao,tao);
    end
    
    // razao entre o tzao e o step do t da funcao continua calculada pela ode. Utilizada para 
    // os valores das aproximacoes de back e forwad na mesma escala temporal da f continua
    razao = Tzao/step;
    //Correspondencias das aproximacoes com elementos de t. Onde o primeiro valor é o t0
    t_correspondente = 1:comprimento;
    t_correspondente(1,1) = t0;
    for i = 2:comprimento
        t_correspondente(1,i) = t(1,(i-1)*razao);
    end
    //Plot para a aproximacao por forward
    subplot(4,2,count+count_auxiliar);
    plot(2);
    title("Por Forward com Tzao = " + string(Tzao) );
    xlabel("Tempo");
    ylabel("y(tempo)");
    plot(t,continua); 
    // Para fazer com que cada y(n) seja plotado isolado, dando o efeito de movimento
    for i = 1:comprimento
        plot(t_correspondente(i),y_discreto_forward(1,i), 'ro-');
        tempo = (60000/(comprimento*30))
        sleep(tempo);
    end 
    //Para inserir a linha que liga os y(n)
    plot(t_correspondente,y_discreto_forward, 'ro-');
    sleep(500);
    
    //Plot para a aproximacao por backward
    subplot(4,2,count+1+count_auxiliar);
    plot(2);
    title("Por Backward com Tzao = " + string(Tzao) );
    xlabel("Tempo");
    ylabel("y(tempo)");
    plot(t,continua);
    for i = 1:comprimento
        plot(t_correspondente(i),y_discreto_backward(1,i), 'ro-');
        tempo = (60000/(comprimento*30))
        sleep(tempo);
    end 
    plot(t_correspondente,y_discreto_backward, 'ro-');
    sleep(500);
end



