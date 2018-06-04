%% Do 500 times experiments and record the results
cd('..');
name = {'route3.mat','route4.mat','route5.mat','route6.mat'};
for bigcnt = 1: 4
    filename = name(bigcnt);
    for cnt = 1: 100
       (bigcnt - 1) * 100 + cnt
       Main();
       data((bigcnt - 1) * 100 + cnt, :) = [maxErrRate_map accErrRate_map maxErrRate_sign accErrRate_sign]; 
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