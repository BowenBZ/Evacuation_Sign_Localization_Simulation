%% Modify the detection ability from 0 to 1 and do the experiments
detectAbiList = [0: 0.1: 1];
cd('..');
for cnt = 1: length(detectAbiList)
    for j = 1: 100
        detectAbi = detectAbiList(cnt);
        Main();
        index = (cnt-1) * 100 + j
        data(index, :) = [maxErrRate_map accErrRate_map maxErrRate_sign accErrRate_sign]; 
    end
end
cd('midterm');