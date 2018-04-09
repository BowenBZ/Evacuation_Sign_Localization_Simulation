function [path_obser index_in index_out]= GenerateObservedPath(path_real, noise, boundaryPoints)
%% Get vectors from the real path
path_copy = path_real;
path_real(end, :) = []; path_copy(1, :) = [];
vector = path_copy - path_real;           % 惯性单元测量出来的是位置点之间的增量
%% Add noise
vector_length = (sum(vector.^2, 2)).^(1/2);
vector(find(vector(:, 1) == 0), 1) = 0.0001;
vector_angle = GetAngle(vector(:, 1), vector(:, 2));
obvector_length = vector_length .* (1 + 0.004 * randn(length(vector_length), 1));
obvector_angle = vector_angle .* (1 + 0.08 * randn(1, length(vector_angle)));

%{
newVector(:, 1) = vector_length_n .* cos(vector_angle_n);
newVector(:, 2) = vector_length_n .* sin(vector_angle_n);
%}
newVector = awgn(vector, noise);
figure; subplot(1,2,1); hold on; plot(vector_length); hold off;axis([0 length(vector_length) 0.4 0.6]); %plot(obvector_length); hold off; axis([0 length(vector_length) 0.4 0.6]); legend('real', 'observed');
subplot(1,2,2); hold on; plot(vector_angle); %{plot(obvector_angle); hold off; legend('real', 'observed');
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