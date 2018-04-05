function [path_obser index_in index_out]= GenerateObservedPath(path_real, noisedb, boundaryPoints)
%% Add noise to the real path
path_copy = path_real;
path_real(length(path_real), :) = []; path_copy(1, :) = [];
measurements = path_copy - path_real;           % 惯性单元测量出来的是位置点之间的增量
measurements = awgn(measurements, noisedb);     % 给每次测量的增量都加入高斯噪声
path_obser(1, :) = path_real(1, :);
for cnt = 1: length(measurements)
    path_obser(cnt + 1, :) = path_obser(cnt, :) + measurements(cnt, :);
end
%% Get the index of in the corridor and out of the corridor
index = inpolygon(path_obser(:, 1), path_obser(:, 2), ...
        boundaryPoints(:, 1), boundaryPoints(:, 2));
index_in = find(index == 1); 
index_out = find(index == 0);
end