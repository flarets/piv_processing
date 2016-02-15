function [dm] = plot_histogram(d, bw, type)

% Orignally Dist_1_L.m by Laurisa Swarmy
% Accepts array of diameters, and histogram type
% Outputs histogram and curve fit

figure();
h = histogram(d, 'BinWidth', bw, 'EdgeColor', 'r');

[N, edges] = histcounts(d, h.NumBins);
values = edges(2:end);
count = table(N', values');
count.Properties.VariableNames{1} = 'count';
count.Properties.VariableNames{2} = 'Radius_Value';

h = histfit(d, h.NumBins, type);

% find mean diameter
hmax = max(h(2).YData);
for i=1:length(h(2).XData)
    if h(2).YData(i) == hmax
        dm = h(2).XData(i);
        break
    end
end

% show mean diameter
ylim=get(gca,'ylim');
line([dm,dm], ylim,'Color','g');

title(sprintf('histogram with %s fit',type));
xlabel('diameter, \mum');
ylabel('number of particles');
