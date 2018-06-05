%% Get the coordinate of evacuation signs
clear
clc
img = imread('fit6_gray.jpg');
imshow(img);
signCoordinate = ginput();
% signType = 