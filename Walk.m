function path = Walk(startPoint, endPoint, speed, frequency)
%% Return a simulated real walking path with motion noise according to the input
%% startPoint, endPoint: 2-dimensional coordinates(m); speed: (m/s); frequency: (Hz)
walkDirection = (endPoint - startPoint) / norm(endPoint - startPoint);
%% Form the route and add length noise to each point
lengthNoise = 0.01;
dx = 1 / frequency * speed;
cnt = 1; 
path(cnt, :) = startPoint;
while(norm(path(cnt, :) - endPoint) >= 2 * dx)
    cnt = cnt + 1;
    stepLength = 1 / frequency * speed * (1 + lengthNoise * randn);   % Add noise to length
    path(cnt, :) = path(cnt - 1, :) + walkDirection * stepLength;
end
path(end + 1, :) = endPoint;
%% Add angle noise to each point
angleNoise = 0.2;
for cnt = (length(path) - 1) : -1 : 2
    vector = path(cnt, :) - path(cnt-1, :);
    vector_length = norm(vector);
    vector_angle = GetAngle(vector(1), vector(2));
    stepAngle = vector_angle + angleNoise * randn;
    path(cnt, :) = path(cnt-1, :) + [vector_length * cosd(stepAngle), vector_length * sind(stepAngle)];
end
end