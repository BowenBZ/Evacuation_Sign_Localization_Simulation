function path = Walk(startPoint, endPoint, speed, frequency)
%% Return a simulated walking path according to the input
%% startPoint, endPoint: 2-dimensional coordinates(m); speed: (m/s); frequency: (Hz)
walkLength = norm(endPoint - startPoint);   % (m)
walkDirection = (endPoint - startPoint) / walkLength;
walkTime = walkLength / speed;              % (s)
pointNum = floor(walkTime * frequency);     % (¸ö)
for cnt = 1: pointNum
    path(cnt, :) = startPoint + walkDirection * speed / frequency * (cnt - 1);
end
if(path(cnt, :) ~= endPoint)
    path(cnt + 1, :) = endPoint;
end
end