function [stats, I_bin] = process_image(I_bin, I3)
% Accepts image, and a binary image
% Returns table of particle properties

% process image
stats = regionprops('struct',I_bin,I3,'PixelList','MaxIntensity','MinIntensity','PixelValues','MeanIntensity','WeightedCentroid','MajorAxisLength','MinorAxisLength');

% for each particle, calculate sig_x, sig_y and add to stats
for i=1:length(stats)
    X = stats(i).PixelList(:,1);
    Y = stats(i).PixelList(:,2);
    I = double(stats(i).PixelValues);
    [stats(i).sig_x, stats(i).sig_y] = particle_stdev(X,Y,I);
end

% calculate intensity-weighted particle diameter in pixels and add to stats
% standard deviation = particle radius
% average diameter = r_(x-dir) + r_(y_dir)

for i=1:length(stats)
    stats(i).d_e = ([stats(i).sig_x] + [stats(i).sig_y]);
end

% remove zero-sized entries
filter = [];
for i=1:length(stats)
    if (stats(i).d_e == 0)
        filter = [filter, i]; % indicies to remove
    end
end
stats(filter) = [];
