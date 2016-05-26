function [stats] = filter_asym(stats, a_min, a_max)

filter = [];

for i=1:length(stats)
    a = stats(i).MajorAxisLength/stats(i).MinorAxisLength;
    if (a < a_min) || (a > a_max)
        filter = [filter, i]; % indicies to remove
    end
end

stats(filter) = [];