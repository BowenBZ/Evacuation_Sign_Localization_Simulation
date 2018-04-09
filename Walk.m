function path = Walk(startPoint, endPoint, speed, frequency)
%% Return a simulated walking path according to the input
%% startPoint, endPoint: 2-dimensional coordinates(m); speed: (m/s); frequency: (Hz)
walkDirection = (endPoint - startPoint) / norm(endPoint - startPoint);
walkAngle = atand(walkDirection(2) / walkDirection(1));
% 两个采样点之间的距离为使用平均速度走过的距离
dx = 1 / frequency * speed;
cnt = 1;
path(cnt, :) = startPoint;
while(norm(path(cnt, :) - endPoint) >= 2 * dx)
    cnt = cnt + 1;
    stepAngle = walkAngle * (1 + 0.03 * randn);
    if(walkDirection(1) >= 0)
        stepDirection = [1 tand(stepAngle)] / norm([1 tand(stepAngle)]);
    else
        stepDirection = [-1 -tand(stepAngle)] / norm([-1 -tand(stepAngle)]);
    end
    stepLength = 1 / frequency * speed * (1 + 0.003 * randn);
    path(cnt, :) = path(cnt - 1, :) + stepDirection * stepLength;
end
%{
flagDistance = norm(path(end, :) - endPoint);
if(flagDistance >= 1.5 * dx)
    path(end + 1, :) = (path(end, :) + endPoint) / 2;
    path(end + 1, :) = endPoint;
elseif(flagDistance > 0.8 * dx && flagDistance < 1.5 * dx)
    path(end + 1, :) = endPoint;
end
%}
path(end + 1, :) = endPoint;
end