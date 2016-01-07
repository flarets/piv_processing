function [stats,I2,I3] = process_image(I1, threshold, md)
% Accepts image, threshold value
% Returns table of particle properties

% Convert to grayscale
I2=rgb2gray(I1);

% Detect edges, return binary image
% I3=I2>threshold;
I3 = edge(I2, 'canny', 0.1);

% process image
stats = regionprops('struct',I3,I2,'PixelList','MaxIntensity','MinIntensity','PixelValues','MeanIntensity','WeightedCentroid');

% for each particle, calculate sig_x, sig_y and add to stats
for i=1:length(stats)
    X = stats(i).PixelList(:,1);
    Y = stats(i).PixelList(:,2);
    I = double(stats(i).PixelValues);
    [stats(i).sig_x, stats(i).sig_y] = particle_stdev(X,Y,I);
end

% calculate intensity-weighted particle diameter and add to stats
for i=1:length(stats)
    stats(i).d_e = 0.5*([stats(i).sig_x] + [stats(i).sig_y]);
end

% calculate constant in um/px
m=mean([stats.d_e]); % intensity-weighted mean diameter in pixels
constant=(md/m); % calibration constant, um/pixel

% calculate actual particle diameter and add to stats
for i=1:length(stats)
    stats(i).d_p = constant*stats(i).d_e; % actual diameter
end
