function [particles weight] = UpdateParticle(varargin)
%% Update particle's weight, then remove the low weight's particles, and copy the hight weight's particles
%% particleWeight is a N * 1 array, particles is a N * 2 array

%% Get elements from the varargin
particles = cell2mat(varargin(1));
weight = cell2mat(varargin(2));
prePos = cell2mat(varargin(3));
obserVec = cell2mat(varargin(4));
boundPos = cell2mat(varargin(5));
addSign = cell2mat(varargin(6));
if(addSign)
   currentPos = cell2mat(varargin(7)); 
   signType = cell2mat(varargin(8));
   signPos = cell2mat(varargin(9));
end

%% Update particle's weight according to 
%% 1) Canculate the distance of the particles and the observation
R = 5;
distanceSqu = sum((particles - prePos - obserVec).^2, 2);
distance = distanceSqu.^(1/2);
weight = (1 / sqrt(R) / sqrt(2 * pi)) * exp(-(distance).^2 / 2 / R);
%% 2) the information of the signs
if(addSign)
    [type index distance] = GetEvacualationSignInfo(currentPos, signType, signPos);
    if(type ~= -1)
        distSqu = sum((particles - signPos(index, :)).^2, 2);
        dist = abs(distSqu.^(1/2)) - distance;
        % weight(find(dist > 3)) = 0;
        weight = FuseDistance(weight, dist, R);
    end
end
%% 3) If the particle is out of the corridor, weight set 0
index = inpolygon(particles(:, 1), particles(:, 2), boundPos(:, 1), boundPos(:, 2));
weight(find(index == 0)) = 0;
%% Normalize the weight
if(sum(weight) ~= 0)
    weight = weight / sum(weight);    
else
    weight =  ones(1, length(weight)) * 1 / length(weight);
end
%% Update particles according to its weight
outIndex = residualR(weight');
temp = particles(outIndex, :);
particles = temp;
end