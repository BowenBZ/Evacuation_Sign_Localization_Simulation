function [path maxErr accErr] = PredictMapPath(path_real, path_obser, speed, frequency, boundPos)
%% Parameters
prtcleNum = 1000;
Q = 10000;
prtcle = repmat(path_obser(1,:), [prtcleNum 1]) + sqrt(Q) * randn(prtcleNum, 2);
weight = ones(prtcleNum, 1) * 1 / prtcleNum;    
path(1, :) = sum(prtcle) / prtcleNum;
dt = 1 / frequency;
%% Canculation
for cnt = 2: length(path_obser)
    if(cnt == 2)
        vec = path_obser(cnt, :) - path_obser(cnt-1, :);
    else
        vec = path(cnt-1, :) - path(cnt-2, :);
    end
    % vec = path_obser(cnt, :) - path_obser(cnt-1, :);
    % Update the particles of the next time point
    prtcle = prtcle + vec / norm(vec) * speed * dt + sqrt(Q) * randn(prtcleNum, 2);
    % Canculate the weight of particles and resample the particles
    [prtcle weight] = UpdateParticle(prtcle, weight, ...
        path(cnt-1, :), path_obser(cnt,:) - path_obser(cnt-1, :), boundPos, 0);
    % Canculate the path according to the particle set
    path(cnt, :) = sum(prtcle) / prtcleNum;
end
%% Canculate the errors of path_cons compared with the real path
[maxErr, accErr] = GetPositionError(path_real, path);
end