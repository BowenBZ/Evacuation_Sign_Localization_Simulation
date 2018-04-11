%% Rule of Name: one case in class:path_real, element of the name:angleNoise 
%% Show the map
%clear; clc; close all;
showpic = 0; savepic = 0;
load parameter_part;
if(showpic) 
figure(1); map = imread('fit6_part.jpg'); imshow(map); 
DrawSigns();
end
if(savepic) saveas(gcf, 'output\1.png'); end
%% Generate real walking path
speed = 50; frequency = 100;
[path_real pathLength frequency] = GenerateRealPath('database', 'route3.mat');
% [path_real pathLength frequency] = GenerateRealPath('manaual', speed, frequency);
%% Show real walking path
if(showpic) figure(1); hold on; scatter(path_real(:, 1), path_real(:, 2), 0.7, 'r', 'filled'); hold off; end
if(savepic) saveas(gcf, 'output\2.png'); end
%% Get the observed path
lengthStd = [300, 50]; angleStd = [3, 1];
[path_obser index_in index_out] = GenerateObservedPath(path_real, lengthStd, angleStd, boundPos, frequency);
%% Show the observed path, in the corridor green, out: blue
if(showpic)
figure(1);
hold on; 
scatter(path_obser(index_in, 1), path_obser(index_in, 2), 1, 'g', 'filled'); 
scatter(path_obser(index_out, 1), path_obser(index_out, 2), 1, 'b', 'filled'); 
hold off;
end
if(savepic) saveas(gcf, 'output\3.png'); end
%% Canculate the 2 errors of the observed path
[maxErr_obser, accErr_obser] = GetPositionError(path_real, path_obser);
fprintf(['Path with noise:\nMax Error: ' num2str(maxErr_obser) ' Accumulate Error: ' num2str(accErr_obser) '\n']);
%% Prediction
%{
[path_kalman maxErr_kalman accErr_kalman] = PredictKalmanPath(path_real, path_obser, signType, signPos, frequency);
figure(1); hold on; scatter(path_kalman(:, 1), path_kalman(:, 2), 1, [1 0 1], 'filled');
%% Canculate the errors of path_cons compared with the observed path
maxErrRate_kalman = (maxErr_obser - maxErr_kalman) / maxErr_obser * 100; 
accErrRate_kalman = (accErr_obser - accErr_kalman) / accErr_obser * 100;
%% Show errors
fprintf(['Path Kalman:\nMax error: ' num2str(maxErr_kalman) ' Accumulate error: ' num2str(accErr_kalman) '\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_kalman) '%% Accumulate error decrease: ' num2str(accErrRate_kalman) '%%\n']);
%}
%% Fuse map to the path
[path_map maxErr_map accErr_map] = PredictMapPath(path_real, path_obser, speed, frequency, boundPos);
%% Show the path confused with construction
if(showpic) figure(1); hold on; scatter(path_map(:, 1), path_map(:, 2), 1, [1 0 1], 'filled'); hold off; end
if(savepic) saveas(gcf, 'output\5.png'); end
%% Canculate the errors of path_cons compared with the observed path
maxErrRate_map = (maxErr_obser - maxErr_map) / maxErr_obser * 100; 
accErrRate_map = (accErr_obser - accErr_map) / accErr_obser * 100;
%% Show errors
fprintf(['Path coufused construction:\nMax error: ' num2str(maxErr_map) ' Accumulate error: ' num2str(accErr_map) '\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_map) '%% Accumulate error decrease: ' num2str(accErrRate_map) '%%\n']);
%% Fuse signs to the path
signWeight = 0.05;
[path_sign maxErr_sign accErr_sign] = PredictSignPath(path_real, path_obser, speed, frequency, boundPos, signType, signPos, signWeight);
%% Show the path confused with signs
if(showpic) figure(1); hold on; scatter(path_sign(:, 1), path_sign(:, 2), 1, [0 0 0], 'filled'); hold off; end
if(savepic) saveas(gcf, 'output\6.png'); end
%% Canculate the 2 errors of the path with noise cofused with signs
maxErrRate_sign = (maxErr_obser - maxErr_sign) / maxErr_obser * 100;
accErrRate_sign = (accErr_obser - accErr_sign) / accErr_obser * 100;
%% Show error
fprintf(['Path coufused sign:\nMax error: ' num2str(maxErr_sign) ' Accmulate error: ' num2str(accErr_sign) '\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_sign) '%% Accmulate error decrease: ' num2str(accErrRate_sign) '%% \n']);