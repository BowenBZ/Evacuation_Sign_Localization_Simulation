%% Get the coordinate of evacuation signs
clear
clc
addpath('./database');
img = imread('fit6_gray2.jpg');
imshow(img);
pos = ginput();
% signType = 