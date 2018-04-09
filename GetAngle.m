function angle = GetAngle(x, y)
if(x>=0)
    angle = atand(y/x);
else
    if(y<0)
        angle = atand(y/x) - 180;
    else
        angle = 180 + atand(y/x);
    end
end
end