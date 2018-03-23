%% Show the map
clear; clc;
map = imread('fit6.jpg'); imshow(map); title('FIT6楼平面图');
load signType; load signCoordinate; load boundaryPoints;
DrawSigns();
%% Generate the path
[path pathLength frequency] = GeneratePath('database', 'route.mat');
% [path pathLength frequency] = GeneratePath('manaual', 50, 100);
%% Show the path
hold on; scatter(path(:, 1), path(:, 2), 0.7, 'r', 'filled'); hold off;
%% Add noise to the path data
noise = 0.5;
path_noise = GeneratePathWithError(path, noise);
%% Show the path with noise, the part out of the corridor is blue, inside is green
in=inpolygon(path_noise(:, 1), path_noise(:, 2), ...
        boundaryPoints(:, 1), boundaryPoints(:, 2));
inCorr = find(in == 1); outCorr = find(in == 0);
hold on; 
scatter(path_noise(inCorr, 1), path_noise(inCorr, 2), 0.7, 'g', 'filled'); 
scatter(path_noise(outCorr, 1), path_noise(outCorr, 2), 0.7, 'b', 'filled'); 
hold off;
%% Canculate the 2 errors of the path with noise
[maxError_noise, accError_noise] = GetPositionError(path, path_noise);
%% Fuse construction to the path
particleNum = 100;            % 粒子个数
% initialOffset= 20;          % 撒粒子范围
prtcleWeight_cons = ones(1, particleNum) * 1 / particleNum;        % 粒子权值
distance = norm(path_noise(1, :) - path_noise(2, :)); Q = 5; theta = pi / length(path_noise);

% realOffset = -initialOffset + 2 * initialOffset * rand(particleNum, 2);
realOffset = distance * [-cos(1 * theta) sin(1 * theta)] + wgn(particleNum, 2, 10 * log10(Q));
particleSet_construction = repmat(path_noise(1,:), [particleNum 1]) + realOffset;
path_fuseConstruction(1, :) = path_noise(1, :);
for cnt = 2: length(path_noise)
    % realOffset = -initialOffset + 2 * initialOffset * rand(particleNum, 2);
    realOffset = distance * [-cos(cnt * theta) sin(cnt * theta)] + wgn(particleNum, 2, 10 * log10(Q));
    particleSet_construction = particleSet_construction + realOffset; 
    
    [prtcleWeight_cons particleSet_construction] = UpdateParticle(prtcleWeight_cons, particleSet_construction, path_noise(cnt, :), 0, cnt);
    path_fuseConstruction(cnt, 1) = prtcleWeight_cons * particleSet_construction(:, 1);
    path_fuseConstruction(cnt, 2) = prtcleWeight_cons * particleSet_construction(:, 2);
end
hold on;
scatter(path_fuseConstruction(:, 1), path_fuseConstruction(:, 2), 1, [1 0 1], 'filled');
hold off;
%% Canculate the 2 errors of the path with noise cofused with construction
[maxError_construction, accError_construction] = GetPositionError(path, path_fuseConstruction);
%% Fuse signs to the path
particleNum = 100;            % 粒子个数
particleWeight_sign = ones(1, particleNum) * 1 / particleNum;   % 粒子权值
distance = norm(path_noise(1, :) - path_noise(2, :)); Q = 5; theta = pi / length(path_noise);
realOffset = distance * [-cos(1 * theta) sin(1 * theta)] + wgn(particleNum, 2, 10 * log10(Q));
prtcleSet_sign = repmat(path_noise(1,:), [particleNum 1]) + realOffset;
path_fuseSign(1, :) = path_noise(1, :);
for cnt = 2: length(path_noise)
    % realOffset = -initialOffset + 2 * initialOffset * rand(particleNum, 2);
    realOffset = distance * [-cos(cnt * theta) sin(cnt * theta)] + wgn(particleNum, 2, 10 * log10(Q));
    prtcleSet_sign = prtcleSet_sign + realOffset; 
    
    [particleWeight_sign prtcleSet_sign] = UpdateParticle(particleWeight_sign, prtcleSet_sign, path_noise(cnt, :), 0, cnt);
    path_fuseSign(cnt, 1) = particleWeight_sign * prtcleSet_sign(:, 1);
    path_fuseSign(cnt, 2) = particleWeight_sign * prtcleSet_sign(:, 2);
end
hold on;
scatter(path_fuseSign(:, 1), path_fuseSign(:, 2), 1, [0 0 0], 'filled');
hold off;
%% Canculate the 2 errors of the path with noise cofused with signs
[maxError_sign, accError_sign] = GetPositionError(path, path_fuseSign);
%% Show error
fprintf(['Path with noise:\nMax error: ' num2str(maxError_noise) ' Acc error: ' num2str(accError_noise) '\n']);
fprintf(['Path coufused construction:\nMax error: ' num2str(maxError_construction) ' Acc error: ' num2str(accError_construction) '\n']);
fprintf(['Path coufused sign:\nMax error: ' num2str(maxError_sign) ' Acc error: ' num2str(accError_sign) '\n']);