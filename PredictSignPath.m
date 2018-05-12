function [path maxErr accErr] = PredictSignPath(para)
%% Fuse 2D Map and Signs information to the observed path using particle filter 
%% Paremeters
path_real = para{1};
path_obser = para{2};
speed = para{3};
frequency = para{4};
boundPos = para{5};
signType = para{6};
signPos = para{7};
signWeight = para{8}; 
detectAbi = para{9};
prtcleNum = para{10};
prdctRadiSqu = para{11};

prtcle = repmat(path_obser(1,:), [prtcleNum 1]) + sqrt(prdctRadiSqu) * randn(prtcleNum, 2);
weight = ones(1, prtcleNum) * 1 / prtcleNum; 
path(1, :) = sum(prtcle) / prtcleNum;
dt = 1 / frequency;
%% Canculation
for cnt = 2: length(path_obser)
    % Update the particles of the next time point
    if(cnt == 2)
        vec = path_obser(cnt, :) - path_obser(cnt-1, :);
    else
        vec = path(cnt-1, :) - path(cnt-2, :);
    end
    prtcle = prtcle + sqrt(prdctRadiSqu) * randn(prtcleNum, 2); %+ vec / norm(vec) * speed * dt + 
    % Canculate the weight of particles and resample the particles
    [prtcle weight] = UpdateParticle(prtcle, weight, ...
        path(cnt-1, :), path_obser(cnt, :) - path_obser(cnt-1, :), boundPos, 1, ...
            path_real(cnt, :), signType, signPos, signWeight, detectAbi);
    % Canculate the path according to the particle set
    path(cnt, :) = sum(prtcle) / prtcleNum;
end
%% Canculate the errors of path_cons compared with the real path
[maxErr, accErr] = GetPositionError(path_real, path);
end