function pointSquence= GetPointFromMap()
%% Get the point from map and generate a point squence
points = ginput();
points2 = points;
points(length(points), :) = []; points2(1, :) = [];
pointSquence = [points points2];
end