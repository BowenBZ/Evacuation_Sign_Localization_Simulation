for cnt = 1: 500
   cnt
   main();
   data(cnt, :) = [maxErrRate_map accErrRate_map maxErrRate_sign accErrRate_sign]; 
end
save('midterm2.mat');