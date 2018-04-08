function crossPoint = GetCrossPoint(k1, pos1, k2, pos2)
crossPoint(1,1) = (k1*pos1(1) - k2*pos2(1) - pos1(2) + pos2(2)) / (k1 - k2);
crossPoint(1,2) = (k1*k2*(pos1(1) - pos2(1)) + k1*pos2(2) - k2*pos1(1)) / (k1 - k2);
end