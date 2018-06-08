%% Main Program Script
%% Rule of Name: one case in class:path_real, element of the name:angleNoise 
%% Parameters
% clear; clc; close all;
autoload = 1; % 1-auto load   2-handle load
prekalman = 1; 
premap = 0;
presign = 0;

routename = 'route1.mat'; % load route data
mapname = 'fit6_gray2.jpg';

showfig = 1; % whether show figures(every path is in one figure)
savefig = 0; % whether save figures(every path is saved seperately)
showfigNoise = 0; % whether show noise figures(add noise and not)
interval = 20; % draw a path point every 20 points

speed = 50; % the speed of person moves in real path(50 unit / 1 second)
frequency = 100; % the frequency of sensor's detection

lengthStd = [0.1, 0.05]; % std of length every step (unit)
angleStd = [3, 1]; % std of angle every step (deg)

prtcleNum_map = 1000; % the number of particles used in map process
prdctRadiSqu_map = 10; % the square of radius of the prediction area (meter)

prtcleNum_sign = 1000; % the number of particles used in sign process
prdctRadiSqu_sign = 10; % the square of radius of the prediction area (meter)

signWeight = 0.3; % the weight of information from signs(compared with map)(from 0 to 1)
detectAbi = 0.7; % the sensor's detection ability of signs(from 0 to 1)
detectReg = 2; % the max region that sensor can detect (meter)
detectOfs = 0; % the offset of the noise of the sensor's detection (meter)

addpath('./database');
load parameter2;    % includes boundPos, signPos, signType, u2m
prdctRadiSqu_map = (prdctRadiSqu_map / u2m)^2;
prdctRadiSqu_sign = (prdctRadiSqu_sign / u2m)^2;
detectReg = detectReg / u2m;
detectOfs = detectOfs / u2m;
%% Import the original map
map = imread(mapname);
%% Generate real walking path
if(autoload)
    [path_real pathLength frequency] = GePath_Real('database', routename);
else
    [path_real pathLength frequency] = GePath_Real('manaual', speed, frequency, map);
end
% Show real walking path
if(showfig) 
    if(autoload)
       figure(1); imshow(map); DrawSigns(); 
    end
    ShowPath(1, interval, path_real, 10, '.');
    legend('Evacuation Sign', 'Real Path');
end
if(savefig) saveas(gcf, 'output\path-real.png'); end
%% Get the observed path
[path_obser index_in index_out] = GePath_Obser(path_real, lengthStd, angleStd, boundPos, frequency, showfigNoise);
% Show the observed path, in the corridor green, out: blue
if(showfig)
    ShowPath(1, interval, path_obser, 10, '+');
    legend('Evacuation Sign', 'Real Path', 'Observed Path');
end
if(savefig) saveas(gcf, 'output\path-obser.png'); end
% Canculate the 2 errors of the observed path
stepErr_obser = GetPositionError(path_real, path_obser);
fprintf('Path with noise:\n');
PrintError(stepErr_obser * u2m);
%% Kalman Filter
if(prekalman)
tic;
transferParameter = {path_real, path_obser, ...
                     signType,  signPos, frequency};
[path_kalman stepErr_kalman] = PrePath_Kalman(transferParameter);
time_kalman = toc;
% Show the path
if(showfig)
    figure(2); imshow(map); DrawSigns();
    ShowPath(2, interval, path_real, 10, '.');
    ShowPath(2, interval, path_obser, 10, '+');
    ShowPath(2, interval, path_kalman, 10, 'v');
    legend('Evacuation Sign', 'Real Path', 'Observed Path',...
        'Kalman Path');
end
% Print Error
fprintf('Kalman Filter:\n')
PrintError(stepErr_kalman * u2m);
end
%% Fuse map to the path
if(premap)
tic;
transferParameter = {path_real, path_obser, ...
    speed, frequency, boundPos, prtcleNum_map, prdctRadiSqu_map};
[path_map stepErr_map] = PrePath_Map(transferParameter);
time_map = toc;
% Show the path confused with construction
if(showfig)
    figure(3); imshow(map); DrawSigns();
    ShowPath(3, interval, path_real, 10, '.');
    ShowPath(3, interval, path_obser, 10, '+');
    ShowPath(3, interval, path_map, 10, '^');
    legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Fuse Map to Path');
end
if(savefig) saveas(gcf, 'output\path-map.png'); end
% Show errors
fprintf('Path Fused Map:\n');
PrintError(stepErr_map * u2m);
end
%% Fuse signs to the path
if(presign)
tic;
transferParameter = {path_real, path_obser, ...
    speed, frequency, boundPos, signType, signPos, ...
    signWeight, prtcleNum_sign, prdctRadiSqu_sign, ...
    detectAbi, detectReg, detectOfs};
[path_sign stepErr_sign] = PrePath_Sign(transferParameter);
time_sign = toc;
% Show the path confused with signs
if(showfig) 
    figure(4); imshow(map); DrawSigns();
    ShowPath(4, interval, path_real, 10, '.');
    ShowPath(4, interval, path_obser, 10, '+');
    ShowPath(4, interval, path_sign, 10, 'o');
    legend('Evacuation Sign', 'Real Path', 'Observed Path', 'Fuse Sign to Path');
end
if(savefig) saveas(gcf, 'output\path-sign.png'); end
% Show error
fprintf('Path coufused sign:\n');
PrintError(stepErr_sign * u2m);
end
%% Draw step errors
if(showfig)
    figure(5);
    timeline = [1:1:pathLength];
    timeline = (timeline - 1) / 100;
    size = 0.1;
    hold on;
    plot(timeline, stepErr_obser * u2m, 'k:');
    texttype = [0 0 0];
    if(prekalman)
        plot(timeline, stepErr_kalman * u2m, 'k:.');
        texttype = texttype | [1 0 0];
    end
    if(premap)
        plot(timeline, stepErr_map * u2m, 'k--');
        texttype = texttype | [0 1 0];
    end
    if(presign)
        plot(timeline, stepErr_sign * u2m, 'k-');
        texttype = texttype | [0 0 1];
    end
    hold off;
    xlabel('Time(s)'); ylabel('Error(m)');
    ptext = {'Path Kalman Filter', 'Path Fused with Map',...
        'Path Fused with Map and Signs'};
    legendtext = {'Observed Path'};
    for cnt = 1: 3
       if(texttype(cnt))         
           legendtext = {legendtext{:} ptext{cnt}};
       end
    end
    legend(legendtext);
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