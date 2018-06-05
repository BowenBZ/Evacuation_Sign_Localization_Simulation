map = imread('datafiles/fit6.jpg');
map = rgb2gray(map);
imshow(map);
pos = ginput();  % top-left, top-right, bottom-left

row_bg = pos(1, 2);
row_ed = pos(3, 2);
column_bg = pos(1, 1);
column_ed = pos(2, 1);
map2 = map(row_bg: row_ed, column_bg: column_ed);