addpath('..');
clear data;
numlist = [10 100 1000 5000 10000 50000];
repeat_times = 100;
for cnt = 1: length(numlist)
   prtcleNum_map = numlist(cnt);
   prtcleNum_sign = numlist(cnt);
   for ncnt = 1: repeat_times;
       (cnt - 1) * repeat_times + ncnt
       Main();
       data((cnt - 1) * repeat_times + ncnt, :) = ...
       [sum(stepErr_obser) * u2m / length(stepErr_obser), ...
           sum(stepErr_map) * u2m / length(stepErr_map), ...
             sum(stepErr_sign) * u2m / length(stepErr_sign), ...
                time_map, time_sign];
   end
end
save prtcleNum_experiments;