function angle = GetAngle(x, y)
%% Get angles(deg) from slopes in figure's coordinate
list1 = find(x>=0);
list2 = find(x<0 & y<0);
list3 = find(x<0 & y>=0);

angle(list1) = atand(y(list1) ./ x(list1));
angle(list2) = atand(y(list2) ./ x(list2)) - 180;
angle(list3) = 180 + atand(y(list3) ./ x(list3));
end