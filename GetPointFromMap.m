function [bgPoint edPoint]= GetPointFromMap()
%% Get the point from map and generate a point squence
points = ginput();
points_copy = points;
points(end, :) = []; points_copy(1, :) = [];
bgPoint = points; edPoint = points_copy;
end