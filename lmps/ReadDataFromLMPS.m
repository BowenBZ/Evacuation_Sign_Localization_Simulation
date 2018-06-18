function lmpsdata = ReadDataFromLMPS(filename)
origindata = csvread(filename,1,1);
lmpsdata.time = origindata(:, 1);
lmpsdata.acc = origindata(:, 3:5);
lmpsdata.gyro = origindata(:, 6:8);
lmpsdata.mag = origindata(:, 9:11);
lmpsdata.euler = origindata(:, 12:14);
lmpsdata.quat = origindata(:, 15:18);
lmpsdata.linacc = origindata(:, 19:21);
end