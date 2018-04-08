function weight = FuseDistance(weight, dist, R)
%% Fuse dist to weight
%% 1. Dist throw Guassian
dist_weight = (1 / sqrt(R) / sqrt(2 * pi)) * exp(-(dist).^2 / 2 / R);
%% 2. Fuse dist_weight to the 
a = 0.7;
weight = dist_weight * a + weight * (1 - a);
%% 3. Set 0 for those innormal weight
weight(find(dist > 5)) == 0;
end