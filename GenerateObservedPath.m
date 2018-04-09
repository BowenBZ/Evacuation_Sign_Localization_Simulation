function [path_obser index_in index_out]= GenerateObservedPath(path_real, noise, boundaryPoints)
%% Get vectors from the real path
path_copy = path_real;
path_real(end, :) = []; path_copy(1, :) = [];
vector = path_copy - path_real;           % 惯性单元测量出来的是位置点之间的增量
%% Add noise
vector_length = (sum(vector.^2, 2)).^(1/2);
vector_angle = GetAngle(vector(:, 1), vector(:, 2))';
obvector_length = vector_length .* (1 + 0.004 * randn(length(vector_length), 1));
obvector_angle = vector_angle .* (1 + 0.008 * randn(length(vector_angle), 1));
newVector(:, 1) = vector_length .* cosd(vector_angle);
newVector(:, 2) = vector_length .* sind(vector_angle);
%% Show the origin vectors and observed vectors
figure(2); subplot(1,2,1); hold on; plot(vector_length); axis([0 length(vector_length) 0.4 0.6]);%plot(obvector_length); hold off; axis([0 length(vector_length) 0.4 0.6]); legend('real', 'observed');
subplot(1,2,2); hold on; plot(vector_angle); %plot(obvector_angle); hold off; legend('real', 'observed');
%% Generate observed path
path_obser(1, :) = path_real(1, :);
for cnt = 1: length(newVector)
    path_obser(cnt + 1, :) = path_obser(cnt, :) + newVector(cnt, :);
end
%% Get the index of in the corridor and out of the corridor
index = inpolygon(path_obser(:, 1), path_obser(:, 2), ...
        boundaryPoints(:, 1), boundaryPoints(:, 2));
index_in = find(index == 1); 
index_out = find(index == 0);
end