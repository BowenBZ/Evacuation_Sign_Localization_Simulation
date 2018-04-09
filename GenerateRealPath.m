function [path_real pathLength frequency] = GenerateRealPath(varargin)
%% Generate path for the map, can load from database or manaually set
%% source: 'database', 'manual'
%% when source is database, the next element is filename; when source is manaual, 
%% the next element is speed and frequency
if(nargin == 2)
    source = string(varargin(1));
    filename = string(varargin(2));
    if(source == 'database' )
        load(filename);
    end
elseif(nargin == 3)
    source = string(varargin(1));
    speed = double(string(varargin(2)));
    frequency = double(string(varargin(3)));
    if(source == 'manaual')
        %% Choose key points
        pointSquence = GetPointFromMap();
        pathLength = sum(sum(abs(pointSquence(:,1:2) - pointSquence(:, 3:4)).^2, 2).^(1/2));
        %% Generate the path
        for cnt = 1: size(pointSquence, 1)
            if(exist('path_real', 'var'))
                % Generate a new path
                newPart = Walk(pointSquence(cnt, 1:2), pointSquence(cnt, 3:4), speed, frequency);              
                % Generate some middle points;
                smoothIndex_pre = 3; smoothIndex_cur = 3;
                vector_pre = pointSquence(cnt-1, 3:4) - pointSquence(cnt-1, 1:2);
                vector_cur = pointSquence(cnt, 3:4) - pointSquence(cnt, 1:2);
                middlePoints = VectorInterp([path_real(end - (smoothIndex_pre - 1): end, :);
                                             newPart(2: smoothIndex_cur, :)], ...
                                                vector_pre, vector_cur, speed, frequency);
                path_real(end - (smoothIndex_pre - 1): end, :) = []; 
                newPart(1: smoothIndex_cur, :) = [];
                % Path joint
                path_real = [path_real; middlePoints; newPart];
            else
                path_real = Walk(pointSquence(cnt, 1:2), pointSquence(cnt, 3:4), speed, frequency);
            end
        end
        %% Add system noise to the real path
        % path_real = Theory2Real(path_std);
        path_real(end - 2: end, :) = [];
    end
end