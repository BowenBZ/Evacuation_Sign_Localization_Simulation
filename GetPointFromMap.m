function pointSquence= GetPointFromMap()
%% Get the point from map and generate a point squence
points = ginput();
points_copy = points;
points(end, :) = []; points_copy(1, :) = [];
pointSquence = [points points_copy];
end