function [path maxErr accErr] = PredictMapPath(para)
%% Fuse 2D Map information to the observed path using particle filter 
%% Parameters
path_real = para{1};
path_obser = para{2};
speed = para{3}; 
frequency = para{4};
boundPos = para{5};
prtcleNum = para{6};
prdctRadiSqu = para{7};

prtcle = repmat(path_obser(1,:), [prtcleNum 1]) + sqrt(prdctRadiSqu) * randn(prtcleNum, 2);
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
    % Update the particles of the next time point
    prtcle = prtcle + vec / norm(vec) * speed * dt + sqrt(prdctRadiSqu) * randn(prtcleNum, 2);
    % Canculate the weight of particles and resample the particles
    [prtcle weight] = UpdateParticle(prtcle, weight, ...
        path(cnt-1, :), path_obser(cnt,:) - path_obser(cnt-1, :), boundPos, 0);
    % Canculate the path according to the particle set
    path(cnt, :) = sum(prtcle) / prtcleNum;
end
%% Canculate the errors of path_cons compared with the real path
[maxErr, accErr] = GetPositionError(path_real, path);
end