cd('..')
clear data;
radiuslist = [0.005 0.01 0.05 0.1 0.5 1 1.5 2 3 4 5];
repeat_times = 100;
for cnt = 1: length(radiuslist)
   temp = radiuslist(cnt);
   prdctRadiSqu_map = (temp / u2m) ^ 2;
   prdctRadiSqu_sign = (temp / u2m) ^ 2;
   for ncnt = 1: repeat_times
       (cnt - 1) * repeat_times + ncnt
       main();
       data((cnt - 1) * repeat_times + ncnt, :) = ...
       [sum(stepErr_obser) * u2m / length(stepErr_obser), ...
           sum(stepErr_map) * u2m / length(stepErr_map), ...
             sum(stepErr_sign) * u2m / length(stepErr_sign)];
   end
end
save prtcleRadius_experiments3.mat;