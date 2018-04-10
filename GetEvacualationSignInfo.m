function [type index distance] = GetEvacualationSignInfo(currentPos, signType, signCoordinate)
%% Get the type of the signs and the distance towards to the sign
%% type: -1: Not detect signs
detectionThresDistance = 200;
distanceList = (sum(abs(signCoordinate - currentPos).^2,2).^(1/2));
[minDistance index] = min(distanceList);
if(minDistance > detectionThresDistance)
    type = -1;
    distance = 0;
else
    type = signType(index);
    distance = minDistance;
end