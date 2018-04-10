function pos_interp = VectorInterp(pos_ori, vec1, vec2, speed, frequency)
%% Cure Smoothing
%% Generate the varied vectors
ang1 = GetAngle(vec1(1), vec1(2)); ang2 = GetAngle(vec2(1), vec2(2));
if(abs(ang2 - ang1) > 180)  % Gurantee the delta angle is acute angle
    ang1 = ang1 + 360;
end
dang = (ang2 - ang1) / (length(pos_ori) - 1);
%% Use two slopes and two points get the crooss point to smooth the corner
vecBE = pos_ori(end, :) - pos_ori(1, :);
kBE = - vecBE(1) / vecBE(2);
pos_interp(1, :) = pos_ori(1, :);
if(abs(vecBE(2)) > 1*10^(-6))
    for cnt = 2: (size(pos_ori, 1) - 1)
        tempSlope = tand(ang1 + (cnt - 1) * dang);
        pos_interp(cnt, :) = GetCrossPoint(kBE, pos_ori(cnt,:), tempSlope, pos_interp(cnt-1, :));
    end
else
    for cnt = 2: (size(pos_ori, 1) - 1)
        tempSlope = tand(ang1 + (cnt - 1) * dang);
        pos_interp(cnt, 1) = pos_ori(cnt, 1);
        pos_interp(cnt ,2) = tempSlope * (pos_ori(cnt, 1) - pos_interp(cnt-1, 1)) + pos_interp(cnt-1, 2);
    end
end
pos_interp(end + 1, :) = pos_ori(end, :);
%% Add just the distance of each point
dx_the = 1 / frequency * speed;
for cnt = 2: size(pos_interp, 1)
   dx_real = norm(pos_interp(cnt, :) - pos_interp(cnt - 1, :));
   if(dx_real > 1.6 * dx_the) 
       middlePoint = (pos_interp(cnt, :) + pos_interp(cnt - 1, :)) / 2;
       frontPos = pos_interp(1: cnt - 1, :);
       belowPos = pos_interp(cnt: end, :);
       pos_interp = [frontPos; middlePoint; belowPos];
   end
end
end