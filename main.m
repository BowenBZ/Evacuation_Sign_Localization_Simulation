%% Main Program Script
%% Rule of Name: one case in class:path_real, element of the name:angleNoise 
%% Parameters
% clear; clc; close all;
filename = 'route3.mat'; % load route data

showfig = 1; % whether show figures(every path is in one figure)
savefig = 0; % whether save figures(every path is saved seperately)
showfigNoise = 0; % whether show noise figures(add noise and not)

speed = 50; % the speed of person moves in real path(50 unit / 1 second)
frequency = 100; % the frequency of sensor's detection

prtcleNum_map = 10000; % the number of particles used in map process
prdctRadiSqu_map = 10; % the square of radius of the prediction area

signWeight = 0.05; % the weight of information from signs(compared with map)
detectAbi = 1; % the sensor's detection ability of signs(from 0 to 1)
prtcleNum_sign = 10000;
prdctRadiSqu_sign = 1000;

load parameter_part;    % includes boundPos, signPos, signType
addpath('./route');
%% Show the original map
if(showfig) 
    figure(1); map = imread('fit6_gray.jpg'); imshow(map); 
    DrawSigns();
end
if(savefig) saveas(gcf, 'output\map.png'); end
%% Generate real walking path
[path_real pathLength frequency] = GenerateRealPath('database', filename);
% [path_real pathLength frequency] = GenerateRealPath('manaual', speed, frequency);
% Show real walking path
if(showfig) 
    interval = 20;
    list = [1:interval:length(path_real)];
    figure(1); hold on;
    scatter(path_real(list, 1), path_real(list, 2), 10, 'r', 'o'); 
    legend('Evacuation Sign', 'Real Path');
    hold off; 
end
if(savefig) saveas(gcf, 'output\path-real.png'); end
%% Get the observed path
lengthStd = [300, 50]; angleStd = [3, 1];
[path_obser index_in index_out] = GenerateObservedPath(path_real, lengthStd, angleStd, boundPos, frequency, showfigNoise);
% Show the observed path, in the corridor green, out: blue
if(showfig)
    interval = 20;
    list = [1:interval:length(path_real)];
    figure(1); hold on;
    scatter(path_obser(list, 1), path_obser(list, 2), 10, 'b', '+'); 
    legend('Evacuation Sign', 'Real Path', 'Observed Path');
    hold off;
end
if(savefig) saveas(gcf, 'output\path-obser.png'); end
% Canculate the 2 errors of the observed path
[maxErr_obser, accErr_obser, stepErr_obser] = GetPositionError(path_real, path_obser);
fprintf(['Path with noise:\nMax Error: ' num2str(maxErr_obser) 'unit  Accumulate Error: ' num2str(accErr_obser) 'unit\n']);
%% Kalman Filter
[path_kalman maxErr_kalman accErr_kalman stepErr_kalman] = PredictKalmanPath(path_real, path_obser, signType, signPos, frequency);
% Show the path
if(showfig)
figure(1); hold on; 
scatter(path_kalman(:, 1), path_kalman(:, 2), 1, [1 0 1], 'filled');
hold off;
legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Kalman Path');
end
if(savefig) saveas(gcf, 'output\path-kalman.png'); end
% Canculate the errors of path_cons compared with the observed path
maxErrRate_kalman = (maxErr_obser - maxErr_kalman) / maxErr_obser * 100; 
accErrRate_kalman = (accErr_obser - accErr_kalman) / accErr_obser * 100;
% Show errors
fprintf(['Path Kalman:\nMax error: ' num2str(maxErr_kalman) ' Accumulate error: ' num2str(accErr_kalman) '\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_kalman) '%% Accumulate error decrease: ' num2str(accErrRate_kalman) '%%\n']);

%{
%% Fuse map to the path
transferParameter = {path_real, path_obser, ...
    speed, frequency, boundPos, prtcleNum_map, prdctRadiSqu_map};
[path_map maxErr_map accErr_map stepErr_map] = PredictMapPath(transferParameter);
% Show the path confused with construction
if(showfig)
    interval = 20;
    list = [1:interval:length(path_real)];
    figure(1); hold on; 
    scatter(path_map(list, 1), path_map(list, 2), 10, [1 0 1], '^'); 
    legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Fuse Map to Path');
    hold off; 
end
if(savefig) saveas(gcf, 'output\path-map.png'); end
% Canculate the errors of path_cons compared with the observed path
maxErrRate_map = (maxErr_obser - maxErr_map) / maxErr_obser * 100; 
accErrRate_map = (accErr_obser - accErr_map) / accErr_obser * 100;
% Show errors
fprintf(['Path coufused construction:\nMax error: ' num2str(maxErr_map) 'unit  Accumulate error: ' num2str(accErr_map) 'unit\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_map) '%% Accumulate error decrease: ' num2str(accErrRate_map) '%%\n']);
%% Fuse signs to the path
transferParameter = {path_real, path_obser, ...
    speed, frequency, boundPos, signType, signPos, ...
    signWeight, detectAbi, prtcleNum_sign, prdctRadiSqu_sign};
[path_sign maxErr_sign accErr_sign stepErr_sign] = PredictSignPath(transferParameter);
% Show the path confused with signs
if(showfig) 
    interval = 10;
    list = [1:interval:length(path_real)];
    figure(1); hold on; 
    scatter(path_sign(list, 1), path_sign(list, 2), 30, [0 0 0], '.');
    legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Fuse Map to Path','Fuse Sign to Path');
    hold off;
end
if(savefig) saveas(gcf, 'output\path-sign.png'); end
% Canculate the 2 errors of the path with noise cofused with signs
maxErrRate_sign = (maxErr_obser - maxErr_sign) / maxErr_obser * 100;
accErrRate_sign = (accErr_obser - accErr_sign) / accErr_obser * 100;
% Show error
fprintf(['Path coufused sign:\nMax error: ' num2str(maxErr_sign) 'unit  Accmulate error: ' num2str(accErr_sign) 'unit\n']);
fprintf(['Max error decrease: ' num2str(maxErrRate_sign) '%% Accmulate error decrease: ' num2str(accErrRate_sign) '%% \n']);
%% Draw step errors
if(showfig)
    figure(2);
    timeline = [1:1:length(stepErr_obser)];
    timeline = (timeline - 1) / 100;
    size = 0.1;
    hold on;
    plot(timeline, stepErr_obser, 'k:');
    plot(timeline, stepErr_map, 'k--');
    plot(timeline, stepErr_sign, 'k-');
    hold off;
    xlabel('Time(s)'); ylabel('Error(unit)'); 
    legend('Observed Path', 'Path Fused with Map', 'Path Fused with Map and Signs');
    if(savefig) saveas(gcf, 'output\error.png'); end
end
%}