function [stats,I6] = process_image(I3)
% Accepts image, known mean diameter
% Returns table of particle properties

% Detect edges, find binary image
I4 = edge(I3, 'canny', 0.1);
I6 = imfill(I4,'holes'); % fill 'holes'
% I6 = I5 - I4; % subtract 'edges' from 'filled holes'

% process image
stats = regionprops('struct',I6,I3,'PixelList','MaxIntensity','MinIntensity','PixelValues','MeanIntensity','WeightedCentroid');

% for each particle, calculate sig_x, sig_y and add to stats
for i=1:length(stats)
    X = stats(i).PixelList(:,1);
    Y = stats(i).PixelList(:,2);
    I = double(stats(i).PixelValues);
    [stats(i).sig_x, stats(i).sig_y] = particle_stdev(X,Y,I);
end

% calculate intensity-weighted particle diameter in pixels and add to stats
for i=1:length(stats)
    stats(i).d_e = 0.5*([stats(i).sig_x] + [stats(i).sig_y]);
end

% remove zero-sized entries
filter = [];
for i=1:length(stats)
    if (stats(i).d_e == 0)
        filter = [filter, i]; % indicies to remove
    end
end
stats(filter) = [];
