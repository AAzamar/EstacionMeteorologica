% Algoritmo para mostrar de forma gráfica la convolución de dos funciones
% el tamaño de n debe ser múltiplo de 3
clearvars;
readChannelID = 1136506; Day = [datetime('2021-05-09 06:25:00') datetime('2021-05-11 06:20:00')];
[luxDay,dia] = thingSpeakRead(readChannelID,'Fields',3,'dateRange',Day,'ReadKey','EMD7N34LI5W8R36M');
dia=(0:length(dia)-1); zise=length(dia); n=[-zise:(zise*2)-1];  y=zeros(1,length(n));  w=length(n)/3;  time=0.10;

% Señal de entrada      x(n)
h1 = transpose([luxDay]);
x = [zeros(1,w), h1, zeros(1,w)];

% Respuesta al impulso  h(n)
sys = tf([0.5 1], [13975 650]);
lx = transpose([1, zeros(1,(zise-1))]);
sys1 = lsim(sys,lx,dia);
h = transpose([sys1]);
hn = [zeros(1,w), h, zeros(1,w)];

% Gráficas de señales iniciales
k = max(conv(x,hn)); ks= k+(k*0.1); k = min(conv(x,hn)); ki= k+(k*0.1);
subplot(3,1,1); plot(n,x);          title('Señal de entrada'); ylabel('x(n)');
subplot(3,1,2); plot(n,hn);         title('Respuesta al impulso'); ylabel('h(n)');
subplot(3,1,3); ylim([ki+26 ks+26]);      title('Señal de salida'); ylabel('y(n)');
pause; 
% Reflexión y ajuste al inicio h(n)
hf = flip(h); i=0; f= ((2*w)-i);
hk = [zeros(1,i), hf, zeros(1,f)];
subplot(3,1,2); plot(n,hk);         title('Respuesta al impulso'); ylabel('h(n)');
pause;
% Desplazamiento y evaluación punto a punto
for i = 0:1:(2*w)
    hk = [zeros(1,i), hf, zeros(1,f)];
    mult0=x.*hk; conv0=sum(mult0); y(i+(w)-1)=conv0;
    subplot(3,1,2); plot(n,hk);    title('Respuesta al impulso'); ylabel('h(n)');
    subplot(3,1,3); plot(n,y+26); ylim([ki+26 ks+26]); title('Señal de salida'); ylabel('y(n)');
    i = i+1; f= ((2*w)-i);
    xlabel('n'); pause(time)
end
pause; close all
