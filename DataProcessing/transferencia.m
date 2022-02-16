clearvars;
readChannelID = 1136506;
Day = [datetime('2021-05-09 06:25:00') datetime('2021-05-10 08:20:00')];
[temDay,dia] = thingSpeakRead(readChannelID,'Fields',1,'dateRange',Day,'ReadKey','EMD7N34LI5W8R36M');
[luxDay,dia] = thingSpeakRead(readChannelID,'Fields',3,'dateRange',Day,'ReadKey','EMD7N34LI5W8R36M');
dia = (0:length(dia)-1);
A =(0.5); B =(21.5)*650;
num = [A 1]; den = [B 650];
sys = tf(num, den);
y = lsim(sys,luxDay,dia)+26;

figure; hold on;
yyaxis left; plot (dia,y); ylim([20 43]);
yyaxis right; plot(dia, temDay); ylim([20 43]);
%plot (dia,luxDay);ylim([0 21000]);
grid; hold off;


%{
figure; hold on;
yyaxis left;
%plot(dia, seno);
plot(dia, temDay); ylim([24 45]);
yyaxis right;
%plot(dia, seno2);
plot(dia, luxDay); ylim([0 21000]);
grid;   hold off;
%}
%{
% Ajuste Fit6° de Temperatura y Luxes, Laplace :
t = transpose(0:1:44);  f = polyfit (t,temDay1,6);
fT = f(1).*t.*t.*t.*t.*t.*t + f(2).*t.*t.*t.*t.*t + f(3).*t.*t.*t.*t + f(4).*t.*t.*t + f(5).*t.*t + f(6).*t + f(7);
%figure; hold on; plot(fT); plot (temDay1); hold off;

syms t; fT = f(1)*t^6 + f(2)*t^5 + f(3)*t^4 + f(4)*t^3 + f(5)*t^2 + f(6)*t + f(7); %f(1)*t^3 + f(2)*t^2 + f(3)*t + f(4);
xs = laplace(fT);
t = transpose(0:1:44);  f = polyfit (t,luxDay1,6);
fL = f(1).*t.*t.*t.*t.*t.*t + f(2).*t.*t.*t.*t.*t + f(3).*t.*t.*t.*t + f(4).*t.*t.*t + f(5).*t.*t + f(6).*t + f(7);
%figure; hold on; plot(fL); plot (luxDay1); hold off;

syms t; fL = f(1)*t^6 + f(2)*t^5 + f(3)*t^4 + f(4)*t^3 + f(5)*t^2 + f(6)*t + f(7);

ys = laplace(fL);
hs = ys / xs;
TranF = ilaplace(hs);

for i=1: 1: 44
    Tfer(i) = TranF(i);
end
figure; plot(Tfer); title('Transferencia - Función');
%}
%{
figure;
hold on
yyaxis left;
plot(dia1,temDay1);
plot(dia,temDay);
ylim([0 46]);
yyaxis right;
plot(dia1,luxDay1);
plot(dia,luxDay);
ylim([0 2e4]);
grid;
hold off

for i=2: 1: length(fT)
    deltaT = fT(i) - fT(i-1);
    deltaL = fL(i) - fL(i-1);
    m(i-1) = [deltaT / deltaL];
end
figure; plot(m);ylim([-.01 .01]); title('m poliFit');

figure;
yyaxis left;
plot(dia,temDay);
ylim([0 46]);
yyaxis right;
plot(dia,luxDay);
ylim([0 2e4]);
%legend({'hoy','ayer'});
%xlabel('Step-Read');
%ylabel('Temperatura');
%title('2-Day Temperature Comparison');
%}
%{
clearvars
readChannelID = 1136506;
[dataY, time] = thingSpeakRead(readChannelID, 'Field', 1, 'NumPoints', 96, 'ReadKey', 'EMD7N34LI5W8R36M');%figure;  %plot(time,dataY);  %grid;

oneDay = [datetime('2021-05-24 02:55:42') datetime('2021-05-25 02:53:29')];
%[data,timestamps,chInfo] = thingSpeakRead(chId,Name,Value)
[temDay1,dia1] = thingSpeakRead(readChannelID,'Fields',1,'dateRange',oneDay, 'ReadKey','EMD7N34LI5W8R36M'); 
[temDay,dia] = thingSpeakRead(readChannelID,'Fields',1,'dateRange',oneDay-days(1),'ReadKey','EMD7N34LI5W8R36M'); 
[temperatureDay3,dia3] = thingSpeakRead(readChannelID,'Fields',1,'dateRange',oneDay-days(2),'ReadKey','EMD7N34LI5W8R36M'); 
% Create array of durations
dia1 = (1:length(temDay1));
dia = (1:length(temDay));
dia3 = (1:length(temperatureDay3));
plot(dia1,temDay1, dia,temDay, dia3, temperatureDay3);
legend({'hoy','ayer','antier'});
xlabel('Step-Read');
ylabel('Temperature');
title('3-Day Temperature Comparison');
%}

