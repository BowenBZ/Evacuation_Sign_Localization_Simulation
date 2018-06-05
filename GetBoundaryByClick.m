%% Get the corridor area
%% The top left is origin point, left to right is +x, up to down is +y
clear;
clc;
map = imread('fit6_gray2.jpg');
imshow(map);
boundPos = ginput();
boundPos(end + 1, :) = boundPos(1, :);
hold on;
plot(boundPos(:, 1), boundPos(:, 2), 'color', [0 0 0]);
hold off;