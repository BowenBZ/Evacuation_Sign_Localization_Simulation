for cnt = 1: 500
   main();
   data(cnt, :) = [maxErrRate_map accErrRate_map maxErrRate_sign accErrRate_sign]; 
end
save('midterm.mat');