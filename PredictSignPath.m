function path_sign = PredictSignPath(path_real, path_obser, boundPos, signType, signPos, signWeight)
prtcleNum_sign = 1000;
Q = 1000;
prtcle_sign = repmat(path_obser(1,:), [prtcleNum_sign 1]) + sqrt(Q) * randn(prtcleNum_sign, 2);
weight_sign = ones(1, prtcleNum_sign) * 1 / prtcleNum_sign;   % Á£×ÓÈ¨Öµ
path_sign(1, :) = sum(prtcle_sign) / prtcleNum_sign;

for cnt = 2: length(path_obser)
    % Update the particles of the next time point
    prtcle_sign = prtcle_sign + sqrt(Q) * randn(prtcleNum_sign, 2); 
    % Canculate the weight of particles and resample the particles
    [prtcle_sign weight_sign] = UpdateParticle(prtcle_sign, weight_sign, ...
        path_sign(cnt-1, :), path_obser(cnt, :) - path_obser(cnt-1, :), boundPos, 1, ...
            path_real(cnt, :), signType, signPos, signWeight);
    % Canculate the path according to the particle set
    path_sign(cnt, :) = sum(prtcle_sign) / prtcleNum_sign;
end
end