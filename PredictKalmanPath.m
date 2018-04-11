function [path maxErr accErr] = PredictKalmanPath(path_real, path_obser, frequency)
%% Parameters
T = 1 / frequency;
N = length(path_real);
delta_w  = 1e -3;
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
%% Convert path_obser to observation value
path_pre = path_real;
path_bel = path_real;
path_pre(end, :) = []; path_bel(1, :) = [];
vector = path_bel - path_pre; 
vector_length = (sum(vector.^2, 2)).^(1/2);
vector_angle = GetAngle(vector(:, 1), vector(:, 2))';
%% EKF
Xekf = zeros(4, N);
Xekf(:, 1) = [path_obser(1,1);
                0.25;
                path_obser(1,2);
                0.25];
P0 = eye(4);
for cnt = 2: N
    Xn = F * Xekf(:, cnt-1);    % Predict state
    P1 = F * P0 * F' + G * Q * G'; % Predict cov 
    dd = Xn - Xekf(:, cnt-1); % Predict observation
    Z(1,1) = norm(dd); 
    Z(2,1) = GetAngle(dd(1), dd(2));
    % Get Jacoobi H
    H = [dd(1)/norm(dd), 0, dd(2)/norm(dd), 0;
        -dd(2)/(norm(dd))^2, 0, dd(1)/(norm(dd))^2, 0];
    K = P1 * H' * inv(H * P1 * H' + R);
    Xekf(:, cnt) = Xn + K * ([vector_length(cnt-1); vector_angle(cnt-1)] - Z);
    P0 = (eye(4) - K * H) * P1;
end
%% Generate the route
path = Xekf([1 3], :)';
%% Canculate the errors of path_cons compared with the real path
[maxErr, accErr] = GetPositionError(path_real, path);
end