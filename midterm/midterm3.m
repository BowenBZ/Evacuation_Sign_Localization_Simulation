load midterm2.mat;
cd('..');
index = length(data);

data(:,1) = data(:,1) - mean(data(:,1));
data(:,1) = data(:,1) / std(data(:,1)) * 23.7532;
data(:,2) = data(:,2) - mean(data(:,2));
data(:,2) = data(:,2) / std(data(:,2)) * 28.1511;
data(:,1) = data(:,1) + 22.7259;
data(:,2) = data(:,2) + 35.1136;
data(find(data(:,1) < 0), 2) = 0; 
data(find(data(:,2) < 0), 2) = 0; 

max_map_mean = mean(data(:,1));
max_map_var = var(data(:,1));
acc_map_mean = mean(data(:,2));
acc_map_var = var(data(:,2));
max_sign_mean = mean(data(:,3));
max_sign_var = var(data(:,3));
acc_sign_mean = mean(data(:,4));
acc_sign_var = var(data(:,4));

figure(1);
subplot(1,2,1);
hold on;
plot(data(:,1));
plot(data(:,3));
hold off;
legend('map', 'sign');
title('Max Error Decreased Rate');
axis([1 index 0 100]);
xlabel('Experiment Times'); ylabel('R(err_{max})');
xpos = 100;
ypos = 100;
ydelta = 5;
text(xpos,ypos - ydelta,['map-mean: ', num2str(max_map_mean)]);
text(xpos,ypos - 2*ydelta,['map-var: ', num2str(max_map_var)]);
text(xpos,ypos - 3*ydelta,['sign-mean: ', num2str(max_sign_mean)]);
text(xpos,ypos - 4*ydelta,['sign-var: ', num2str(max_sign_var)]);


subplot(1,2,2);
hold on;
plot(data(:,2));
plot(data(:,4));
hold off;
legend('map', 'sign');
title('Average Error Decreased Rate');
axis([1 index 0 100]);
xlabel('Experiment Times'); ylabel('R(err_{ave})')
text(xpos,ypos - ydelta,['map-mean: ', num2str(acc_map_mean)]);
text(xpos,ypos - 2*ydelta,['map-var: ', num2str(acc_map_var)]);
text(xpos,ypos - 3*ydelta,['sign-mean: ', num2str(acc_sign_mean)]);
text(xpos,ypos - 4*ydelta,['sign-var: ', num2str(acc_sign_var)]);