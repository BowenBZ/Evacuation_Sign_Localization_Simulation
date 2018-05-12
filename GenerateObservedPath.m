function [path_obser index_in index_out]= GenerateObservedPath(path_real, lengthStd, angleStd, boundPos, frequency, showfigNoise)
%% Get vectors from the real path
path_copy = path_real;
path_real(end, :) = []; path_copy(1, :) = [];
vector = path_copy - path_real; 
%% Get length and angle from vectors
vector_length = (sum(vector.^2, 2)).^(1/2);
vector_angle = GetAngle(vector(:, 1), vector(:, 2))';
%% Generate the Guassian white noise and Random noise
Guassian = randn(length(vector_length), 1); 
Guassian = Guassian - mean(Guassian); Guassian = Guassian / std(Guassian);
dt = 1 / frequency;
gdStd_length = lengthStd(1) / sqrt(dt);     % Guassian White Noise
gdStd_angle = angleStd(1) / sqrt(dt);
bgdStd_length = lengthStd(2) * sqrt(dt);    % Random Noise
bgdStd_angle = angleStd(2) * sqrt(dt);

gw_length = gdStd_length * Guassian;
gw_angle = gdStd_angle * Guassian;
bias_length(1) = 0; bias_angle(1) = 0;
for cnt = 2: length(vector_length)
    bias_length(cnt) = bias_length(cnt-1) + bgdStd_length * Guassian(cnt);
    bias_angle(cnt) = bias_angle(cnt-1) + bgdStd_angle * Guassian(cnt);
end
%% Form observed vectors
obvector_length = vector_length + gw_length + bias_length';
obvector_angle = vector_angle + gw_angle + bias_angle';
obvector = [vector_length.*cosd(obvector_angle) vector_length.*sind(obvector_angle)];
%% Show the origin vectors and observed vectors
if(showfigNoise)
figure(2); subplot(1,2,1); hold on; plot(obvector_length); plot(vector_length); hold off; legend('real', 'observed'); title('Length with Noise'); xlabel('step_k'); ylabel('length(1unit)');
subplot(1,2,2); hold on; plot(obvector_angle); plot(vector_angle);  hold off; legend('real', 'observed'); title('Angle with Noise'); xlabel('step_k'); ylabel('angle(1^o)')
end
%% Generate observed path
path_obser(1, :) = path_real(1, :);
for cnt = 1: length(obvector)
    path_obser(cnt + 1, :) = path_obser(cnt, :) + obvector(cnt, :);
end
%% Get the index of in the corridor and out of the corridor
index = inpolygon(path_obser(:, 1), path_obser(:, 2), ...
        boundPos(:, 1), boundPos(:, 2));
index_in = find(index == 1); 
index_out = find(index == 0);
end