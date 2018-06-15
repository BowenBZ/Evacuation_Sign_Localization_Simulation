clear; clc;
%{
year = [2000: 1: 2016];
fireAcciNum = [18.9 21.7 25.8 25.4 25.3 23.6 23.2 16.4 13.7 12.9 13.2 12.5 15.2 38.9 39.5 34.7 31.2];
moneyloss = [14.4 14.0 15.4 15.9 16.7 13.7 8.6 11.3 18.2 16.2 19.6 20.6 21.8 48.5 47.0 43.6 37.2];
[H A1 A2] = plotyy(year, fireAcciNum, year, moneyloss);
set(A1, 'LineWidth', 3);
set(A2, 'LineWidth', 3);
xlabel('年份'); ylabel(H(1), '火灾数目（万起）'); ylabel(H(2), '财产损失（亿元）');
ylim(H(1), [0 60]); ylim(H(2), [0 60]);
set(H(1), 'yTick', [0:10:60]); set(H(2), 'yTick', [0:10:60]);
%}
%{
year = [2000: 1: 2014];
death = [11 6 7 28 16 6 14 11 14 8 7 6 8 15 13];
hurt = [483 183 746 226 89 47 105 93 108 56 21 49 22 37 16];
[H A1 A2] = plotyy(year, death, year, hurt);
set(A1, 'LineWidth', 3);
set(A2, 'LineWidth', 3);
xlabel('年份'); ylabel(H(1), '死亡人数（人）'); ylabel(H(2), '受伤人数（人）');
ylim(H(1), [0 40]); ylim(H(2), [0 500]);
set(H(1), 'yTick', [0:10:40]); set(H(2), 'yTick', [0:100:500]);
%}
%{
prtcleNum = [10 100 1000 5000 10000];
prtcleNum = log(prtcleNum);
obser = [76.48 76.56 76.74 76.83 76.68];
method1 = [36.11 38.69 37.03 37.35 36.71];
method2 = [15.84 3.68 2.55 2.54 2.38];
time = [0.55 0.93 3.75 15.66 32.09];
figure;
hold on;
scatter(prtcleNum, obser, 'filled');
scatter(prtcleNum, method1, 'filled');
scatter(prtcleNum, method2, 'filled');
plot(prtcleNum, obser, 'b', 'LineWidth', 2);
plot(prtcleNum, method1, 'r', 'LineWidth', 2);
plot(prtcleNum, method2, 'y', 'LineWidth', 2);
hold off;
legend('观测','方法1','方法2');
xlabel('粒子数（log）'); ylabel('平均定位误差（米）');
figure;
hold on;
scatter(prtcleNum, time, 'filled');
plot(prtcleNum, time, 'LineWidth', 2);
hold off;
xlabel('粒子数（log）'); ylabel('运行时间(秒)');
%}
%{
prtcleRadius = [0.005 0.01 0.05 0.1 0.5 1 1.5 2 3 4 5];
prtcleRadius = log(prtcleRadius);
obser = [37.71 37.45 37.57 37.20 37.60 37.61 37.35 37.70 37.58 37.69 37.49];
method1 = [24.90 6.44 23.48 32.76 35.34 36.83 33.93 32.83 30.37 28.49 26.91];
method2 = [39.70 39.79 39.98 40.03 40.31 37.58 12.37 1.54 1.58 1.68 1.84];
figure;
hold on;
scatter(prtcleRadius, obser, 'filled');
scatter(prtcleRadius, method1, 'filled');
scatter(prtcleRadius, method2, 'filled');
plot(prtcleRadius, obser, 'b', 'LineWidth', 2);
plot(prtcleRadius, method1, 'r', 'LineWidth', 2);
plot(prtcleRadius, method2, 'y', 'LineWidth', 2);
hold off;
legend('观测','方法1','方法2');
xlabel('粒子数（log）（米）'); ylabel('平均定位误差（米）');
%}
%{
signWeight = [0 0.01 0.03 0.05 0.1 0.3 0.5 1];
signWeight = log(signWeight);
obser = [37.66 37.41 37.63 37.54 37.90 37.68 37.80 37.33];
method1 = [33.10 30.34 33.06 31.69 32.39 28.55 31.78 32.77];
method2 = [33.88 28.17 1.95 1.62 1.35 1.93 2.50 5.03];
method2_n = [30.99 33.33 6.88 2.97 2.13 2.07 2.36 3.09];
figure;
hold on;
scatter(signWeight, obser, 'filled');
scatter(signWeight, method1, 'filled');
scatter(signWeight, method2, 'filled');
scatter(signWeight, method2_n, 'filled');
plot(signWeight, obser, 'b', 'LineWidth', 2);
plot(signWeight, method1, 'r', 'LineWidth', 2);
plot(signWeight, method2, 'y', 'LineWidth', 2);
plot(signWeight, method2_n, 'color', [126, 47, 142] / 255, 'LineWidth', 2);
hold off;
legend('观测','方法1','方法2','方法2（带检测误差）');
xlabel('指示牌权值（log）'); ylabel('平均定位误差（米）');
%}
%{
detectReg = [1 2 3 4 5];
obser = [37.65 37.58 37.14 37.63 37.60];
method1 = [31.03 31.74 33.52 33.14 32.52];
method2 = [1.68 1.93 1.57 1.58 1.55];
figure;
hold on;
scatter(detectReg, obser, 'filled');
scatter(detectReg, method1, 'filled');
scatter(detectReg, method2, 'filled');
plot(detectReg, obser, 'b', 'LineWidth', 2);
plot(detectReg, method1, 'r', 'LineWidth', 2);
plot(detectReg, method2, 'y', 'LineWidth', 2);
hold off;
legend('观测','方法1','方法2');
xlabel('检测半径（米）'); ylabel('平均定位误差（米）');
%}
%{
detectAbi = [0:0.1:1];
obser = [37.51 37.47 37.41 37.34 37.26 37.93 37.30 37.73 37.16 37.73 37.45];
method1 = [31 29.17 29.23 29.55 33.17 33.72 30.02 31.31 30.02 31.13 31.90];
method2 = [30 29.85 23 19.72 12.55 6.57 2.02 1.81 1.72 1.61 1.52];
figure;
hold on;
scatter(detectAbi, obser, 'filled');
scatter(detectAbi, method1, 'filled');
scatter(detectAbi, method2, 'filled');
plot(detectAbi, obser, 'b', 'LineWidth', 2);
plot(detectAbi, method1, 'r', 'LineWidth', 2);
plot(detectAbi, method2, 'y', 'LineWidth', 2);
hold off;
legend('观测','方法1','方法2');
xlabel('识别率'); ylabel('平均定位误差（米）');
%}
distanceNoise = [0 0.5 1 2 3];
obser = [37.54 38.13 37.69 37.37 37.62];
method1 = [32.14 35.02 31.82 33.10 37.62];
method2 = [1.61 27.37 27.50 24.36 24.62];
figure;
hold on;
scatter(distanceNoise, obser, 'filled');
scatter(distanceNoise, method1, 'filled');
scatter(distanceNoise, method2, 'filled');
plot(distanceNoise, obser, 'b', 'LineWidth', 2);
plot(distanceNoise, method1, 'r', 'LineWidth', 2);
plot(distanceNoise, method2, 'y', 'LineWidth', 2);
hold off;
legend('观测','方法1','方法2');
xlabel('距离检测误差（米）'); ylabel('平均定位误差（米）');