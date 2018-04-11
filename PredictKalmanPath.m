function path_kalman = PredictKalmanPath(path_real, path_obser, frequency)
%% Parameters
T = 1 / frequency;
N = length(path_real);
delta_w  = 1e-3;
Q = delta_w * diag([0.5, 1]);
G = [T^2/2, 0;
    T, 0;
    0, T^2/2;
    0, T];
R = 5;
F = [1, T, 0, 0;
    0, 1, 0, 0;
    0, 0, 1, T;
    0, 0, 0, 1];
%% EKF
Xekf = zeros(4, N);
Xekf(:, 1) = [path_obser(1,1);
                0.25;
                path_obser(1,2);
                0.25];
P0 = eye(4);
for cnt = 2:N
    
end
end