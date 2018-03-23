function [type index distance] = GetEvacualationSignInfo(currentPos, signType, signCoordinate)
%% Get the type of the signs and the distance towards to the sign
%% type: -1 表示没有获取到, 当前位置距离标识牌40以上则记为没有看见标识牌
detectionThresDistance = 40;
distanceList = (sum(abs(signCoordinate - currentPos).^2,2).^(1/2));
[minDistance index] = min(distanceList);
if(minDistance > detectionThresDistance)
    type = -1;
    distance = 0;
else
    type = signType(index);
    distance = minDistance;
end