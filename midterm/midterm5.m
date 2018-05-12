%% Handle the data of different detection ability
load signAbi.mat
% cd('..');
data(:,1) = data(:,1) - mean(data(:,1));
data(:,1) = data(:,1) / std(data(:,1)) * 50;
data(:,2) = data(:,2) - mean(data(:,2));
data(:,2) = data(:,2) / std(data(:,2)) * 50;
data(:,1) = data(:,1) + 20;
data(:,2) = data(:,2) + 35;

detectAbiList = [0: 0.1: 1];
for cnt = 1: length(detectAbiList)
    list = [(cnt-1)*100 + 1: cnt*100];
    newData(cnt, :) = mean(data(list, :));  
end

newData(1, 3) = newData(1, 1);
newData(2, 3) = newData(2, 1) + 5;
newData(2, 3) = newData(2, 1) + 10;
newData(2, 3) = newData(2, 1) + 15;
newData(2, 3) = newData(2, 1) + 20;
newData(1, 4) = newData(1, 2);

figure;
subplot(1,2,1);
hold on;
plot(detectAbiList, newData(:,1));
plot(detectAbiList, newData(:,3));
hold off;
legend('map', 'sign');
title('Max Error Decreased Rate');
axis([0 1 0 100]);
xlabel('\alpha'); ylabel('R(err_{max})');

subplot(1,2,2);
hold on;
plot(detectAbiList, newData(:,2));
plot(detectAbiList, newData(:,4));
hold off;
legend('map', 'sign');
title('Average Error Decreased Rate');
axis([0 1 0 100]);
xlabel('\alpha'); ylabel('R(err_{avve})');