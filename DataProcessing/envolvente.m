% Algoritmo para escalar los datos de entrada en Thinkspeak o Arduino 
clearvars -except a b
a = transpose([21,279,1073,2300,4000,6500,10000,13500,17500,21500,26000,30000,34000,38200,42200,46200,50500,54200,57000,59500,61500,63000,64000,64500,64500,64000,63000,61500,59500,57000,54200,50500,46200,42200,38200,34000,30000,26000,21500,17500,13500,10000,6500,4000,2300,1073,279,21]);
b = transpose([20,103,252,429,618,829,1385,2195,2650,3060,3892,4426,6514,8230,9370,9340,11059,12485,13155,13625,14015,14514,14995,15546,15785,15292,14947,14955,14602,13410,12676,12154,10132,8944,7974,7471,6306,5304,4524,3694,2769,1953,713,524,263,104,30,5]);
t = transpose(0:1:47);
% División y ajuste fit de los originales a - b
div = a./b;
f = polyfit (t,div,4);
fdiv = f(1).*t.*t.*t.*t + f(2).*t.*t.*t + f(3).*t.*t + f(4).*t + f(5);
hold on;
plot(t,div);
plot(t,fdiv);
hold off;
% Entrada de dato y escalamiento
datoY = 10700;
f = polyfit (t,b,4);
f = [f(1), f(2), f(3), f(4), f(5)-datoY];
raices = roots (f);
for i=1:1:4
    x = raices(i);
    if (x > 0) && (x < 25)
        f = polyfit (t,fdiv,4);
        escala = f(1)*x*x*x*x + f(2)*x*x*x + f(3)*x*x + f(4)*x + f(5);
        result = datoY * escala;
    end
end
%clearvars -except a b escala result

%{
% Ajuste Fit de a - b de 4° :
f = polyfit (t,a,4);
fa = f(1).*t.*t.*t.*t + f(2).*t.*t.*t + f(3).*t.*t + f(4).*t + f(5);
f = polyfit (t,b,4);
fb = f(1).*t.*t.*t.*t + f(2).*t.*t.*t + f(3).*t.*t + f(4).*t + f(5);

%Gráficas fa-fb y div-escala
figure;
hold on;
plot(t,a);
plot(t,fa);
plot(t,b);
plot(t,fb);
hold off;
figure;
hold on;
plot(t,div);
plot(t,fdiv);
hold off;
%}


