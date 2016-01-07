function [stats] = filter_asym(stats, a_min, a_max)

filter = [];

for i=1:length(stats)
    a = stats(i).sig_x/stats(i).sig_y;
    if (a < a_min) || (a > a_max)
        filter = [filter, i]; % indicies to remove
    end
end

stats(filter) = [];