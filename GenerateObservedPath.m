function [path_obser index_in index_out]= GenerateObservedPath(path_real, lengthStd, angleStd, boundaryPoints)
%% Get vectors from the real path
path_copy = path_real;
path_real(end, :) = []; path_copy(1, :) = [];
vector = path_copy - path_real;           % 惯性单元测量出来的是位置点之间的增量
%% Add noise
vector_length = (sum(vector.^2, 2)).^(1/2);
vector_angle = GetAngle(vector(:, 1), vector(:, 2))';
Guassian = randn(length(vector_length), 1); 
Guassian = Guassian - mean(Guassian); Guassian = Guassian - std(Guassian);

obvector_length = vector_length + lengthStd * Guassian;
obvector_angle = vector_angle + angleStd * Guassian;
%{
obvector = awgn(vector, 1, 'measured', 'linear');
obvector_length = (sum(obvector.^2, 2)).^(1/2);
obvector_angle = GetAngle(obvector(:, 1), obvector(:, 2))';
%}
%{
SNR_length = 10; SNR_angle = 10;
obvector_length = awgn(vector_length, 10, 'measured', 'linear');    % Guassian White Noise
obvector_angle = awgn(vector_angle, 10, 'measured', 'linear');
%}
obvector = [vector_length.*cosd(obvector_angle) vector_length.*sind(obvector_angle)];
%% Show the origin vectors and observed vectors
figure(2); subplot(1,2,1); hold on; plot(vector_length); plot(obvector_length); hold off; legend('real', 'observed'); %axis([0 length(vector_length) 0.4 0.6]);
subplot(1,2,2); hold on; plot(vector_angle); plot(obvector_angle); hold off; legend('real', 'observed');
%% Generate observed path
path_obser(1, :) = path_real(1, :);
for cnt = 1: length(obvector)
    path_obser(cnt + 1, :) = path_obser(cnt, :) + obvector(cnt, :);
end
%% Get the index of in the corridor and out of the corridor
index = inpolygon(path_obser(:, 1), path_obser(:, 2), ...
        boundaryPoints(:, 1), boundaryPoints(:, 2));
index_in = find(index == 1); 
index_out = find(index == 0);
end