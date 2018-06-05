addpath('..');
clear data;
weightlist = [0 0.01 0.03 0.05 0.1 0.3 0.5 1];
repeat_times = 100;
detectAbi = 1;
for cnt = 1: length(weightlist)
   signWeight = weightlist(cnt);
   for ncnt = 1: repeat_times;
       (cnt - 1) * repeat_times + ncnt
       Main();
       data((cnt - 1) * repeat_times + ncnt, :) = ...
       [sum(stepErr_obser) * u2m / length(stepErr_obser), ...
           sum(stepErr_map) * u2m / length(stepErr_map), ...
             sum(stepErr_sign) * u2m / length(stepErr_sign)];
   end
end
save signWeight_experiments.mat;

abilist = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0];
signWeight = 0.05;
for cnt = 1: length(abilist)
   detectAbi = abilist(cnt);
   for ncnt = 1: repeat_times;
       (cnt - 1) * repeat_times + ncnt
       Main();
       data2((cnt - 1) * repeat_times + ncnt, :) = ...
       [sum(stepErr_obser) * u2m / length(stepErr_obser), ...
           sum(stepErr_map) * u2m / length(stepErr_map), ...
             sum(stepErr_sign) * u2m / length(stepErr_sign)];
   end
end
save detectAbility_experiment.mat;