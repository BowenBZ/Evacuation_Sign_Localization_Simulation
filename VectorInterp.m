function point = VectorInterp(pos, vec1, vec2, speed, frequency)
%% Cure Smoothing
%% Generate the varied vectors
ang1 = GetAngle(vec1(1), vec1(2)); ang2 = GetAngle(vec2(1), vec2(2));
if(abs(ang2 - ang1) > 180)  % Gurantee the delta angle is acute angle
    ang1 = ang1 + 360;
end
dang = (ang2 - ang1) / (length(pos) - 1);
%% Use two slopes and two points get the crooss point to smooth the corner
vecBE = pos(end, :) - pos(1, :);
kBE = - vecBE(1) / vecBE(2);
point(1, :) = pos(1, :);
if(abs(vecBE(2)) > 1*10^(-6))
    for cnt = 2: (size(pos, 1) - 1)
        tempK = tand(ang1 + (cnt - 1) * dang);
        point(cnt, :) = GetCrossPoint(kBE, pos(cnt,:), tempK, point(cnt-1, :));
    end
else
    for cnt = 2: (size(pos, 1) - 1)
        tempK = tand(ang1 + (cnt - 1) * dang);
        point(cnt, 1) = pos(cnt, 1);
        point(cnt ,2) = tempK * (pos(cnt, 1) - point(cnt-1, 1)) + point(cnt-1, 2);
    end
end
point(end + 1, :) = pos(end, :);
%% Add just the distance of each point
dx_the = 1 / frequency * speed;
for cnt = 2: size(point, 1)
   dx_real = norm(point(cnt, :) - point(cnt - 1, :));
   if(dx_real > 1.6 * dx_the) 
       middlePoint = (point(cnt, :) + point(cnt - 1, :)) / 2;
       temp1 = point(1: cnt - 1, :);
       temp3 = point(cnt: end, :);
       point = [temp1; middlePoint; temp3];
   end
end
end