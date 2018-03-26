%% Draw evacualation signs and corridor's boundary
hold on;
plot(boundaryPoints(:, 1), boundaryPoints(:, 2), 'color', [0 0 0], 'linewidth', 1.4);
scatter(signCoordinate(:, 1), signCoordinate(:, 2), 'filled');
for cnt = 1: length(signCoordinate)
    switch signType(cnt)
        case 0
            showTypeText = 'Exit';
            offset = 30;
        case 1
            showTypeText = 'Left';
            offset = -30;
        case 2
            showTypeText = 'right';
            offset = -30;
        case 3
            showTypeText= 'two-way';
            offset = -30;
    end
    text(signCoordinate(cnt, 1) - 25, signCoordinate(cnt, 2) + offset, showTypeText, 'FontSize', 15);
end
hold off;