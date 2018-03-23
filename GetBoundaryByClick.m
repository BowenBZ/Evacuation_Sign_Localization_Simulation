%% Get the corridor area
%% The top left is origin point, left to right is +x, up to down is +y
clear;
clc;
map = imread('fit6.jpg');
imshow(map);
boundaryPoints = ginput();
boundaryPoints(end + 1, :) = boundaryPoints(1, :);
hold on;
plot(boundaryPoints(:, 1), boundaryPoints(:, 2), 'color', [0 0 0]);
hold off;