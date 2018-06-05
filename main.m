%% Main Program Script
%% Rule of Name: one case in class:path_real, element of the name:angleNoise 
%% Parameters
% clear; clc; close all;
filename = 'route3.mat'; % load route data

showfig = 1; % whether show figures(every path is in one figure)
savefig = 1; % whether save figures(every path is saved seperately)
showfigNoise = 0; % whether show noise figures(add noise and not)
interval = 20; % draw a path point every 20 points

speed = 50; % the speed of person moves in real path(50 unit / 1 second)
frequency = 100; % the frequency of sensor's detection

prtcleNum_map = 10000; % the number of particles used in map process
prdctRadiSqu_map = 10; % the square of radius of the prediction area

signWeight = 0.05; % the weight of information from signs(compared with map)
detectAbi = 1; % the sensor's detection ability of signs(from 0 to 1)
prtcleNum_sign = 10000; % the number of particles used in sign process
prdctRadiSqu_sign = 1000; % the square of radius of the prediction area

addpath('./database');
load parameter2;    % includes boundPos, signPos, signType
%% Show the original map
if(showfig) 
    figure(1); map = imread('fit6_gray2.jpg'); imshow(map); 
    DrawSigns();
end
if(savefig) saveas(gcf, 'output\map.png'); end
%% Generate real walking path
[path_real pathLength frequency] = GePath_Real('database', filename);
% [path_real pathLength frequency] = GePath_Real('manaual', speed, frequency);
% Show real walking path
if(showfig) 
    ShowPath(1, interval, path_real, 10, '.');
    legend('Evacuation Sign', 'Real Path');
end
if(savefig) saveas(gcf, 'output\path-real.png'); end
%% Get the observed path
lengthStd = [0.050, 0.01]; angleStd = [3, 1];
[path_obser index_in index_out] = GePath_Obser(path_real, lengthStd, angleStd, boundPos, frequency, showfigNoise);
% Show the observed path, in the corridor green, out: blue
if(showfig)
    interval = 20;
    ShowPath(1, interval, path_obser, 10, '+');
    legend('Evacuation Sign', 'Real Path', 'Observed Path');
end
if(savefig) saveas(gcf, 'output\path-obser.png'); end
% Canculate the 2 errors of the observed path
stepErr_obser = GetPositionError(path_real, path_obser);
fprintf('Path with noise:\n');
PrintError(stepErr_obser * u2m);
%{
%% Kalman Filter
transferParameter = {path_real, path_obser, ...
                     signType,  signPos, frequency};
[path_kalman stepErr_kalman] = PrePath_Kalman(transferParameter);
% Show the path
if(showfig)
figure(1); hold on; 
scatter(path_kalman(:, 1), path_kalman(:, 2), 1, [1 0 1], 'filled');
hold off;
legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Kalman Path');
end
%}
%% Fuse map to the path
transferParameter = {path_real, path_obser, ...
    speed, frequency, boundPos, prtcleNum_map, prdctRadiSqu_map};
[path_map stepErr_map] = PrePath_Map(transferParameter);
% Show the path confused with construction
if(showfig)
    ShowPath(1, interval, path_map, 10, '^');
    legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Fuse Map to Path'); 
end
if(savefig) saveas(gcf, 'output\path-map.png'); end
% Show errors
fprintf('Path coufused map:\n');
PrintError(stepErr_map * u2m);
%% Fuse signs to the path
transferParameter = {path_real, path_obser, ...
    speed, frequency, boundPos, signType, signPos, ...
    signWeight, detectAbi, prtcleNum_sign, prdctRadiSqu_sign};
[path_sign stepErr_sign] = PrePath_Sign(transferParameter);
% Show the path confused with signs
if(showfig) 
    figure(2); imshow(map); 
    DrawSigns();
    ShowPath(2, interval, path_real, 10, '.');
    ShowPath(2, interval, path_obser, 10, '+');
    ShowPath(2, interval, path_sign, 10, 'o');
    legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Fuse Sign to Path');
end
if(savefig) saveas(gcf, 'output\path-sign.png'); end
% Show error
fprintf('Path coufused sign:\n');
PrintError(stepErr_sign * u2m);
%% Draw step errors
if(showfig)
    figure(3);
    timeline = [1:1:length(stepErr_obser)];
    timeline = (timeline - 1) / 100;
    size = 0.1;
    hold on;
    plot(timeline, stepErr_obser * u2m, 'k:');
    plot(timeline, stepErr_map * u2m, 'k--');
    plot(timeline, stepErr_sign * u2m, 'k-');
    hold off;
    xlabel('Time(s)'); ylabel('Error(m)'); 
    legend('Observed Path', 'Path Fused with Map', 'Path Fused with Map and Signs');
    if(savefig) saveas(gcf, 'output\error.png'); end
end

function ShowPath(fNum, interval, path, size, shape)
list = [1:interval:length(path)];
figure(fNum); hold on;
scatter(path(list, 1), path(list, 2), size, 'k', shape); 
hold off; 
end

function PrintError(stepErr)
maxErr = max(stepErr);
meanErr = sum(stepErr) / length(stepErr);
fprintf(['Max Error: ' num2str(maxErr) ' m  Mean Error: ' num2str(meanErr) ' m\n']);
end