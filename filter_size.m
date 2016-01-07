function [stats] = filter_size(stats, d_min, d_max)

filter = [];

for i=1:length(stats)
    if (stats(i).d_p < d_min) || (stats(i).d_p > d_max)
        filter = [filter, i]; % indicies to remove
    end
end

stats(filter) = [];