function [path pathLength frequency] = GenerateRealPath(varargin)
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
        for cnt = 1: length(pointSquence)
            if(exist('path', 'var'))
                path = [path; Walk(pointSquence(cnt, 1:2), pointSquence(cnt, 3:4), speed, frequency)];
            else
                path = Walk(pointSquence(cnt, 1:2), pointSquence(cnt, 3:4), speed, frequency);
            end
        end
    end
end