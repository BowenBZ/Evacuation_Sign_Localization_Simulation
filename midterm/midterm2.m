%% Do 500 times experiments and record the results
cd('..');
for cnt = 1: 500
   cnt
   Main();
   data(cnt, :) = [maxErrRate_map accErrRate_map maxErrRate_sign accErrRate_sign]; 
end
save('midterm2.mat');
cd('midterm');