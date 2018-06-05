%% Do 500 times experiments and record the results
cd('..');
name = {'route1.mat','route2.mat','route3.mat'};
for bigcnt = 1: 3
    filename = name(bigcnt);
    for cnt = 1: 100
       (bigcnt - 1) * 100 + cnt
       Main();
       data((bigcnt - 1) * 100 + cnt, :) = ...
           [max(stepErr_obser) * u2m, ...
            max(stepErr_map) * u2m, ...
            max(stepErr_sign) * u2m, ...
           sum(stepErr_obser) * u2m / length(stepErr_obser), ...
            sum(stepErr_map) * u2m / length(stepErr_map), ...
             sum(stepErr_sign) * u2m / length(stepErr_sign)];
    end
end
save('midterm2.mat');
cd('midterm');

%% Do 500 times experiments and record the results
%{
cd('..');
name = {'route3.mat','route4.mat','route5.mat','route6.mat'};
for bigcnt = 1: 4
    filename = name(bigcnt);
    for cnt = 1: 100
       (bigcnt - 1) * 100 + cnt
       Main();
       data((bigcnt - 1) * 100 + cnt, :) = [maxErr_obser accErr_obser]; 
    end
end
save('midterm2.mat');
cd('midterm');
%}