% Plot raw b-transients wrt power (to check background condition)

data=dlmread('b036-s16-Bpower-z-bin1.dat');
time=dlmread('b036-sXX-Bpower-x-bin1.dat');

figure
plot([time time(end)+time],[data(:,6) data(:,6)])