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
        [bgPoint edPoint] = GetPointFromMap();
        pathLength = sum(sum(abs(bgPoint - edPoint).^2, 2).^(1/2));
        %% Generate the path
        for cnt = 1: size(bgPoint, 1)
            if(exist('path_real', 'var'))
                % Generate a new path
                newPart = Walk(bgPoint(cnt, :), edPoint(cnt, :), speed, frequency);              
                % Generate some middle points;
                smoothIndex_pre = 3; smoothIndex_cur = 3;
                smoothIndex_cur = min(3, length(newPart));
                vector_pre = edPoint(cnt-1, :) - bgPoint(cnt-1, :);
                vector_cur = edPoint(cnt, :) - bgPoint(cnt, :);
                middlePoints = VectorInterp([path_real(end - (smoothIndex_pre - 1): end, :); ...
                                             newPart(2: smoothIndex_cur, :)], ...
                                                vector_pre, vector_cur, speed, frequency);
                % Remove the repeated points
                path_real(end - (smoothIndex_pre - 1): end, :) = []; 
                newPart(1: smoothIndex_cur, :) = [];
                % Path joint
                path_real = [path_real; middlePoints; newPart];
            else
                path_real = Walk(bgPoint(cnt, :), edPoint(cnt, :), speed, frequency);
            end
        end
        %% Remove the end points
        path_real(end - 2: end, :) = [];
    end
end