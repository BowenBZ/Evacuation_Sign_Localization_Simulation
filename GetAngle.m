function angle = GetAngle(x, y)
%% Get angles from slopes in figure's coordinate
if(abs(x) < 1e-6)
    if(y>0)
        angle = 90;
        return;
    else
        angle = -90;
        return;
    end
end

list1 = find(x>=0);
list2 = find(x<0);
list3 = find(y(list2)<0);
list4 = find(y(list2)>=0);

angle(list1) = atand(y(list1) ./ x(list1));
angle(list3) = atand(y(list3) ./ x(list3)) - 180;
angle(list4) = 180 + atand(y(list4) ./ x(list4));
end