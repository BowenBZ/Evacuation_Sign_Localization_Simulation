function [path_real pathLength frequency] = GenerateRealPath(varargin)
%% Generate path for the map, can choose to load from database or manaually set
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
        [bgPos edPos] = GetPosFromMap();
        pathLength = sum(sum(abs(bgPos - edPos).^2, 2).^(1/2));
        %% Generate the path
        for cnt = 1: size(bgPos, 1)
            if(exist('path_real', 'var'))
                % Generate a new path
                newPart = Walk(bgPos(cnt, :), edPos(cnt, :), speed, frequency);              
                % Generate some middle points;
                smoothIndex_pre = 3; smoothIndex_cur = 3;
                smoothIndex_cur = min(3, length(newPart));
                vector_pre = edPos(cnt-1, :) - bgPos(cnt-1, :);
                vector_cur = edPos(cnt, :) - bgPos(cnt, :);
                middlePoints = VectorInterp([path_real(end - (smoothIndex_pre - 1): end, :); ...
                                             newPart(2: smoothIndex_cur, :)], ...
                                                vector_pre, vector_cur, speed, frequency);
                % Remove the repeated points
                path_real(end - (smoothIndex_pre - 1): end, :) = []; 
                newPart(1: smoothIndex_cur, :) = [];
                % Path joint
                path_real = [path_real; middlePoints; newPart];
            else
                path_real = Walk(bgPos(cnt, :), edPos(cnt, :), speed, frequency);
            end
        end
        %% Remove the end points
        path_real(end - 2: end, :) = [];
    end
end
end

%% Return a simulated real walking path with motion noise according to the input
function path = Walk(bgPos, edPos, speed, frequency)
%% startPoint, endPoint: 2-dimensional coordinates(m); speed: (m/s); frequency: (Hz)
walkDirection = (edPos - bgPos) / norm(edPos - bgPos);
%% Form the route and add length noise to each point
lengthStd = 0.01;  %(unit length)
dx = 1 / frequency * speed;
cnt = 1; 
path(cnt, :) = bgPos;
while(norm(path(cnt, :) - edPos) >= 2 * dx)
    cnt = cnt + 1;
    stepLength = 1 / frequency * speed * (1 + lengthStd * randn);   % Add noise to length
    path(cnt, :) = path(cnt - 1, :) + walkDirection * stepLength;
end
path(end + 1, :) = edPos;
%% Add angle noise to each point
angleStd = 0.2;   %(deg)
for cnt = (length(path) - 1) : -1 : 2
    vector = path(cnt, :) - path(cnt-1, :);
    vector_length = norm(vector);
    vector_angle = GetAngle(vector(1), vector(2));
    stepAngle = vector_angle + angleStd * randn;
    path(cnt, :) = path(cnt-1, :) + [vector_length * cosd(stepAngle), vector_length * sind(stepAngle)];
end
end

%% Cure Smoothing
function pos_interp = VectorInterp(pos_ori, vec1, vec2, speed, frequency)
%% Generate the varied vectors
ang1 = GetAngle(vec1(1), vec1(2)); ang2 = GetAngle(vec2(1), vec2(2));
if(abs(ang2 - ang1) > 180)  % Gurantee the delta angle is acute angle
    ang1 = ang1 + 360;
end
dang = (ang2 - ang1) / (length(pos_ori) - 1);
%% Use two slopes and two points get the crooss point to smooth the corner
vecBE = pos_ori(end, :) - pos_ori(1, :);
kBE = - vecBE(1) / vecBE(2);
pos_interp(1, :) = pos_ori(1, :);
if(abs(vecBE(2)) > 1*10^(-6))
    for cnt = 2: (size(pos_ori, 1) - 1)
        tempSlope = tand(ang1 + (cnt - 1) * dang);
        pos_interp(cnt, :) = GetCrossPoint(kBE, pos_ori(cnt,:), tempSlope, pos_interp(cnt-1, :));
    end
else
    for cnt = 2: (size(pos_ori, 1) - 1)
        tempSlope = tand(ang1 + (cnt - 1) * dang);
        pos_interp(cnt, 1) = pos_ori(cnt, 1);
        pos_interp(cnt ,2) = tempSlope * (pos_ori(cnt, 1) - pos_interp(cnt-1, 1)) + pos_interp(cnt-1, 2);
    end
end
pos_interp(end + 1, :) = pos_ori(end, :);
%% Add just the distance of each point
dx_the = 1 / frequency * speed;
for cnt = 2: size(pos_interp, 1)
   dx_real = norm(pos_interp(cnt, :) - pos_interp(cnt - 1, :));
   if(dx_real > 1.6 * dx_the) 
       middlePoint = (pos_interp(cnt, :) + pos_interp(cnt - 1, :)) / 2;
       frontPos = pos_interp(1: cnt - 1, :);
       belowPos = pos_interp(cnt: end, :);
       pos_interp = [frontPos; middlePoint; belowPos];
   end
end
end

function crossPoint = GetCrossPoint(k1, pos1, k2, pos2)
crossPoint(1,1) = (k1*pos1(1) - k2*pos2(1) - pos1(2) + pos2(2)) / (k1 - k2);
crossPoint(1,2) = k1*(crossPoint(1, 1) - pos1(1)) + pos1(2);
end

function [bgPos edPos]= GetPosFromMap()
%% Get the point from map and generate a point squence
points = ginput();
points_copy = points;
points(end, :) = []; points_copy(1, :) = [];
bgPos = points; edPos = points_copy;
end