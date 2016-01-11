function [stats] = filter_pixel_size(stats, p_min, p_max)

filter = [];
for i=1:length(stats)
    if (stats(i).d_e < p_min) || (stats(i).d_e > p_max)
        filter = [filter, i]; % indicies to remove
    end
end
stats(filter) = [];