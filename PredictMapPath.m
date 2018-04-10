function path_map = PredictMapPath(path_real, path_obser, boundPos)
prtcleNum_map = 1000;
Q = 1000;
prtcle_map = repmat(path_obser(1,:), [prtcleNum_map 1]) + sqrt(Q) * randn(prtcleNum_map, 2);
weight_map = ones(prtcleNum_map, 1) * 1 / prtcleNum_map;    
path_map(1, :) = sum(prtcle_map) / prtcleNum_map;

for cnt = 2: length(path_obser) 
    % Update the particles of the next time point
    prtcle_map = prtcle_map + sqrt(Q) * randn(prtcleNum_map, 2);
    % Canculate the weight of particles and resample the particles
    [prtcle_map weight_map] = UpdateParticle(prtcle_map, weight_map, ...
        path_map(cnt-1, :), path_obser(cnt,:) - path_obser(cnt-1, :), boundPos, 0);
    % Canculate the path according to the particle set
    path_map(cnt, :) = sum(prtcle_map) / prtcleNum_map;
end
end