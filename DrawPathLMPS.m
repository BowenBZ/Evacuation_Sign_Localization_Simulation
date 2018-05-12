lmpsdata = ReadDataFromLMPS('test.csv');
dt = lmpsdata.time(2) - lmpsdata.time(1);

for cnt = 1: length(lmpsdata.time)
    alpha = lmpsdata.euler(cnt, 1);
    beta = lmpsdata.euler(cnt, 2);
    gamma = lmpsdata.euler(cnt, 3);

    Rz_alpha = Rz(alpha);
    Rx_beta = Rx(beta);
    Rz_gamma = Rz(gamma);
    R = Rz_alpha * Rx_beta * Rz_gamma;

    newacc = inv(R) * lmpsdata.acc';
end
figure(1)
subplot(3,1,1); plot(lmpsdata.acc(:, 1));
subplot(3,1,2); plot(lmpsdata.acc(:, 2));
subplot(3,1,3); plot(lmpsdata.acc(:, 3)); 

figure(2)
subplot(3,1,1); plot(newacc(1, :));
subplot(3,1,2); plot(newacc(2, :));
subplot(3,1,3); plot(newacc(3, :)); 

function matrix = Rx(value)
matrix = [1 0 0;
          0 cosd(value) -sind(value);
          0 sind(value) cosd(value)];
end

function matrix = Ry(value)
matrix = [cosd(value) 0 sind(value);
          0 1 0;
          -sind(value) 0 cosd(value)];
end

function matrix = Rz(value)
matrix = [cosd(value) -sind(value) 0;
          sind(value) cosd(value) 0;
          0 0 1];
end