function [stats] = scale_data(stats, dp_m, de_m)

% calculate constant in um/px
constant = (dp_m/de_m); % calibration constant, um/pixel

% calculate actual particle diameter and add to stats
for i=1:length(stats)
    stats(i).d_p = constant*stats(i).d_e; % actual diameter
end
