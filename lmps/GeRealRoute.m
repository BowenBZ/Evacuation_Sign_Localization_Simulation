function path_real = GeRealRoute()
%% Generate real path according to the time line
map = imread('fit6_gray2.jpg');
load keypos.mat;
frequency = 100;
timeline = input('Please input time squence: \n');
for cnt = 2: length(keypoint)
    if(exist('path_real', 'var'))
       newPart = Walk(keypos(cnt-1, :), keypos(cnt, :), ...
           timeline(cnt) - timeline(cnt-1), frequency);     
       % Generate some middle points;
        smoothIndex_pre = 3; smoothIndex_cur = 3;
        smoothIndex_cur = min(3, length(newPart));
        vector_pre = edPos(cnt-1, :) - bgPos(cnt-1, :);
        vector_cur = edPos(cnt, :) - bgPos(cnt, :);
        speed = norm(keypos(cnt, :) - keypos(cnt-1, :)) / ...
            (timeline(cnt) - timeline(cnt-1));
        middlePoints = VectorInterp([path_real(end - (smoothIndex_pre - 1): end, :); ...
                                     newPart(2: smoothIndex_cur, :)], ...
                                        vector_pre, vector_cur, speed, frequency);
        % Remove the repeated points
        path_real(end - (smoothIndex_pre - 1): end, :) = []; 
        newPart(1: smoothIndex_cur, :) = [];
        % Path joint
        path_real = [path_real; middlePoints; newPart];
    else
       path_real = Walk(keypos(cnt-1, :), keypos(cnt, :), ...
           timeline(cnt) - timeline(cnt-1), frequency);
    end
end
end

function path = Walk(bgPos, edPos, time, frequency)
%% startPoint, endPoint: 2-dimensional coordinates(m); speed: (m/s); frequency: (Hz)
walkDirection = (edPos - bgPos) / norm(edPos - bgPos);
speed = norm(edPos - bgPos) / time;
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