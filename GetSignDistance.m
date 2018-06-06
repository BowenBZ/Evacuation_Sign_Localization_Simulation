%% Get the type of the signs and the distance towards to the sign
function [type index distance] = GetSignDistance(currentPos, signType, signCoordinate, detectAbi, detectReg, detectOfs)
%% type: -1: Not detect signs
distanceList = (sum(abs(signCoordinate - currentPos).^2,2).^(1/2));
[minDistance index] = min(distanceList);
if(minDistance > detectReg)
    type = -1;
    distance = 0;
else
    type = signType(index);
    Q = 2000;   % observed noise
    distance = minDistance + sqrt(Q) * randn + detectOfs;
end
if(rand>detectAbi)
    type = -1;
    distance = 0;
end
end