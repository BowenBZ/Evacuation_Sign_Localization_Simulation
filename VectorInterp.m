function point = VectorInterp(pos)
%% Cure Smoothing
vec1 = pos(2, :) - pos(1, :); vec2 = pos(end, :) - pos(end-1, :);
ang1 = atand(vec1(2) / vec1(1)); ang2 = atand(vec2(2) / vec2(1));
dang = (ang2 - ang1) / (length(pos) - 1);

vecBE = pos(end, :) - pos(1, :);
kBE = - vecBE(1) / vecBE(2);
point(1, :) = pos(1, :);
for cnt = 2: (length(pos) - 1)
    tempK = tand(ang1 + (cnt - 1) * dang);
    point(cnt, :) = GetCrossPoint(kBE, pos(cnt,:), tempK, pos(cnt-1, :));
end
point(end, :) = pos(end, :);
end