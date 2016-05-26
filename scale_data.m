function [stats] = scale_data(stats, constant)

% calculate actual particle diameter and add to stats
for i=1:length(stats)
    stats(i).d_p = constant*stats(i).d_e; % actual diameter
end
