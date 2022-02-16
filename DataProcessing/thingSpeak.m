% Algoritmo que grafica los ultimos n datos de temperatura y luxes en Trial
clearvars;
readChannelID = [1136506];
readAPIKey = 'EMD7N34LI5W8R36M';
[data1, time1] = thingSpeakRead(readChannelID, 'Field', 1, 'NumPoints', 96, 'ReadKey', readAPIKey);
%[data2, time2] = thingSpeakRead(readChannelID, 'Field', 2, 'NumPoints', 96, 'ReadKey', readAPIKey);
[data3, time3] = thingSpeakRead(readChannelID, 'Field', 3, 'NumPoints', 96, 'ReadKey', readAPIKey);
t = [0:1:95];
seno = (20000*sin(2*pi*0.0104*t-1.9));
seno2 = (10*sin(2*pi*0.0104*t-1.9))+27;

figure;
hold on;
yyaxis left;
plot(time1, seno2);
plot(time1, data1); ylim([25 43]);
%yyaxis right;
%plot(time2, data2);
yyaxis right;
plot(time1, seno);
plot(time3, data3); ylim([0 20000]);
grid;
hold off;




