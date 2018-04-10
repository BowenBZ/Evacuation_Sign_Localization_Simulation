%% Rule of Name: case的class(真实的路径):class_case, name的element(路径长度):nameElement, 
%% Show the map 10约为1m
clear; clc; close all;
savepic = 0;
load parameter_part;
figure(1); map = imread('fit6_part.jpg'); imshow(map);
DrawSigns();
if(savepic) saveas(gcf, 'output\1.png'); end
%% Generate real walking path
[path_real pathLength frequency] = GenerateRealPath('database', 'route3.mat');
% [path_real pathLength frequency] = GenerateRealPath('manaual', 50, 100);
%% Show real walking path
figure(1); hold on; scatter(path_real(:, 1), path_real(:, 2), 0.7, 'r', 'filled'); hold off;
if(savepic) saveas(gcf, 'output\2.png'); end
%% Get the observed path
lengthStd = [300, 50]; angleStd = [3, 1];
[path_obser index_in index_out] = GenerateObservedPath(path_real, lengthStd, angleStd, boundPos, frequency);
%% Show the observed path, in the corridor green, out: blue
figure(1);
hold on; 
scatter(path_obser(index_in, 1), path_obser(index_in, 2), 1, 'g', 'filled'); 
scatter(path_obser(index_out, 1), path_obser(index_out, 2), 1, 'b', 'filled'); 
hold off;
if(savepic) saveas(gcf, 'output\3.png'); end
%% Canculate the 2 errors of the observed path
[maxErr_obser, accErr_obser] = GetPositionError(path_real, path_obser);
fprintf(['Path with noise:\nMax Error: ' num2str(maxErr_obser) ' Accumulate Error: ' num2str(accErr_obser) '\n']);
%% Fuse map to the path
path_map = PredictMapPath(path_real, path_obser, boundPos);
%% Show the path confused with construction
figure(1); hold on; scatter(path_map(:, 1), path_map(:, 2), 1, [1 0 1], 'filled'); hold off;
if(savepic) saveas(gcf, 'output\5.png'); end
%% Canculate the errors of path_cons compared with the observed path
[maxErr_map, accErr_map] = GetPositionError(path_real, path_map);
maxErrRate_map = (maxErr_obser - maxErr_map) / maxErr_obser * 100; 
accErrRate_map = (accErr_obser - accErr_map) / accErr_obser * 100;
%% Show errors
fprintf(['Path coufused construction:\nMax error: ' num2str(maxErr_map) ' Accumulate error: ' num2str(accErr_map) '\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_map) '%% Accumulate error decrease: ' num2str(accErrRate_map) '%%\n']);
%% Fuse signs to the path
signWeight = 0.05;
path_sign = PredictSignPath(path_real, path_obser, boundPos, signType, signPos, signWeight);
%% Show the path confused with signs
figure(1); hold on; scatter(path_sign(:, 1), path_sign(:, 2), 1, [0 0 0], 'filled'); hold off;
if(savepic) saveas(gcf, 'output\6.png'); end
%% Canculate the 2 errors of the path with noise cofused with signs
[maxErr_sign, accErr_sign] = GetPositionError(path_real, path_sign);
maxErrRate_sign = (maxErr_obser - maxErr_sign) / maxErr_obser * 100;
accErrRate_sign = (accErr_obser - accErr_sign) / accErr_obser * 100;
%% Show error
fprintf(['Path coufused sign:\nMax error: ' num2str(maxErr_sign) ' Accmulate error: ' num2str(accErr_sign) '\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_sign) '%% Accmulate error decrease: ' num2str(accErrRate_sign) '%% \n']);
%% Use Particle Filter
%{
prtcleNum = 100;
Q = 10;
R = 1;
step(1).Xpf = zeros(prtcleNum, 2);         % 粒子滤波估计状态
step(1).Xparticles = zeros(prtcleNum, 2);  % 粒子集合
step(1).Zpre_pf = zeros(prtcleNum, 2);     % 粒子滤波观测预测值
step(1).weight = zeros(prtcleNum, 1);      % 权重初始化

step(1).Xpf = path_noise(1, :) + sqrt(Q) * randn(prtcleNum, 2);
step(1).Zpre_pf = step(1).Xpf;

for k = 2: length(path_noise)
   for i = 1: prtcleNum
      QQ = Q; 
      net = sqrt(QQ) * randn(1, 2);
      step(k).Xparticles(i, :) = step(k - 1).Xpf(i, :) + net;
   end
   
   for i = 1: prtcleNum
      step(k).Zpre_pf(i, :) = step(k).Xparticles(i, :);
      step(k).weight(i, :) = exp(-0.5 * R ^(-1) * (norm(path_noise(k, :) - step(k).Zpre_pf(i, :)))^2);
   end
   step(k).weight(:, 1) = step(k).weight(:, 1)./sum(step(k).weight);
   
   outIndex = residualR(step(k).weight(:,1)');
   
   step(k).Xpf = step(k).Xparticles(outIndex, :);
end

bins = 20;
Xmap_pf = zeros(length(path_noise), 2);
for k = 1: length(path_noise)
   %[p, pos] = hist(step(k).Xpf, bins);
   %map = find(p==max(p));
   %Xmap_pf(k, :) = pos(map(1), :);
   Xmap_pf(k, :) = sum(step(k).Xpf) / prtcleNum;
end
hold on; scatter(Xmap_pf(:, 1), Xmap_pf(:, 2), 1, [1 0 1], 'filled'); hold off;
%}