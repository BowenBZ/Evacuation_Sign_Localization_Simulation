cd('..');
clear data;
regionlist = [1 2 3 4 5];
repeat_times = 100;
for cnt = 1: length(regionlist)
   detectReg = regionlist(cnt);
   for ncnt = 1: repeat_times;
       (cnt - 1) * repeat_times + ncnt
       main();
       data((cnt - 1) * repeat_times + ncnt, :) = ...
       [sum(stepErr_obser) * u2m / length(stepErr_obser), ...
           sum(stepErr_map) * u2m / length(stepErr_map), ...
             sum(stepErr_sign) * u2m / length(stepErr_sign)];
   end
end
save detectReg_experiments.mat;

clear data2;
ofslist = [0 0.5 1 2 3];
for cnt = 1: length(ofslist)
   detectOfs = ofslist(cnt);
   for ncnt = 1: repeat_times;
       (cnt - 1) * repeat_times + ncnt
       main();
       data2((cnt - 1) * repeat_times + ncnt, :) = ...
       [sum(stepErr_obser) * u2m / length(stepErr_obser), ...
           sum(stepErr_map) * u2m / length(stepErr_map), ...
             sum(stepErr_sign) * u2m / length(stepErr_sign)];
   end
end
save detectOfs_experiment.mat;