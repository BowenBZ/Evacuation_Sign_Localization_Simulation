detectAbiList = [0: 0.1: 1];
for cnt = 1: length(detectAbiList)
    for j = 1: 100
        detectAbi = detectAbiList(cnt);
        main();
        index = (cnt-1) * 100 + j
        data(index, :) = [maxErrRate_map accErrRate_map maxErrRate_sign accErrRate_sign]; 
    end
end