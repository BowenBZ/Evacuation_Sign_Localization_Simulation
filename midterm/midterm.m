clear; clc; close all;
load parameter_part; load midterm;
map = imread('fit6_part.jpg'); imshow(map);
DrawSigns();
ginput();
hold on;
for cnt = 1: length(path_real)
   scatter(path_real(cnt, 1), path_real(cnt, 2), 0.7, 'r', 'filled');
   if(isempty(find(index_in == cnt)))
       scatter(path_obser(cnt, 1), path_obser(cnt, 2), 1, 'b', 'filled'); 
   else
       scatter(path_obser(cnt, 1), path_obser(cnt, 2), 1, 'g', 'filled'); 
   end
   scatter(path_map(cnt, 1), path_map(cnt, 2), 1, [1 0 1], 'filled');
   scatter(path_sign(cnt, 1), path_sign(cnt, 2), 1, [0 0 0], 'filled');
   pause(0.000000000000001);
end
hold off;