%% Draw evacualation signs and corridor's boundary
figure(1);
hold on;
p1 = plot(boundPos(:, 1), boundPos(:, 2), 'color', [217, 83, 25] / 255, 'linewidth', 1.4);
p2 = scatter(signPos(:, 1), signPos(:, 2), 's'); 
set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
legend('Evacuation Sign');
for cnt = 1: length(signPos)
    switch signType(cnt)
        case 0
            showTypeText = 'Exit';
            offset = 30;
        case 1
            showTypeText = 'Left';
            if(cnt ~= length(signPos))
                offset = -30;
            else
                offset = 30;
            end
        case 2
            showTypeText = 'right';
            offset = -30;
        case 3
            showTypeText= 'two-way';
            offset = -30;
    end
    text(signPos(cnt, 1) - 25, signPos(cnt, 2) + offset, showTypeText, 'FontSize', 15);
end
hold off;