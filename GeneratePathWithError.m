function path_accError = GeneratePathWithError(path, db)
%% Add noise to the truly path
path2 = path;
path(length(path), :) = []; path2(1, :) = [];
measurements = path2 - path;
measurements = awgn(measurements, db);
path_accError(1, :) = path(1, :);
for cnt = 1: length(measurements)
    path_accError(cnt + 1, :) = path_accError(cnt, :) + measurements(cnt, :);
end    
end