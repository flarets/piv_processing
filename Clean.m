clc; clear; close all;

% -----------------------------------
% Read image

ifname = 'PIV 1.44lfry23.000000b.bmp';
I1 = imread(ifname);

% Convert to grayscale
I2 = rgb2gray(I1);

% -----------------------------------
% Noise filters

% use 6th order butterworth filter to remove noise
f_c = 0.5; % cutoff frequency
I3 = butterworth_noise_filter(I2,f_c);

% increase image contrast
I3 = contrast_image(I3,0.6);

% matlab contrast function
% I3 = imadjust(I3, [0.4, 0.9], []);

% use a simple grayscale threshold to create binary image
threshold = 55;
I_bin = I3 > threshold;

% Detect edges and fill to create binary image
% I4 = edge(I3, 'canny', 0.1);
% I_bin = imfill(I4, 'holes'); % fill 'holes'
% I_bin = logical(I5 - I4); % subtract 'edges' from 'filled holes'

% use binary image to filter grayscale image
I3 = uint8(I_bin).*I3;

% -----------------------------------
% Get particle data from noise-reduced and binary images

% extract particle data from image
[stats] = process_image(I_bin, I3);

% Filter particles less than 0.5px
p_min = 0.5;  % px
p_max = 20;   % px
[stats] = filter_pixel_size(stats, p_min, p_max);

% find intensity-weighted mean diameter in pixels and scale data
d = [stats.d_e]; % diameters, px
dp_m = 10; % known mean diameter, um
bw = 0.05; % bin width, px
de_m = plot_histogram(d, bw, 'LogNormal');
close(); 
[stats] = scale_data(stats, dp_m, de_m);

% -----------------------------------
% Filter particle data

% Filter based on diameter, um
d_min = 0;  % um
d_max = 30; % um
[stats] = filter_size(stats, d_min, d_max);

% % Filter based on skewness
% a_min = 0.85;
% a_max = 1/0.85;
% [stats] = filter_asym(stats, a_min, a_max);

% -----------------------------------
% Plot particle data

% plot original image
figure()
imshow(I1,'InitialMagnification','fit');
title(sprintf('original image: %s', ifname));

% plot grayscale image, thresholded image, filtered image with identified particles
figure();
ax(4)=subplot(2,2,1);
imshow(I2,'InitialMagnification','fit');
title('grayscale image');

ax(1)=subplot(2,2,2);
imshow(I3,'InitialMagnification','fit');
title('noise removal and threshold');

ax(2)=subplot(2,2,3);
imshow(I_bin,'InitialMagnification','fit');
hold on;
C = reshape([stats.WeightedCentroid],2,length(stats))'; % particle centroids
plot(C(:,1), C(:,2), 'bx');
hold off;
title('binary image and centroids');

ax(3) = subplot(2,2,4);
imshow(I1,'InitialMagnification','fit');
hold on;
radii = 0.5*[stats.d_e]; % particle radii
viscircles(C,radii);
hold off;
title('original image with identified particles');

linkaxes(ax,'xy'); % link axes

d = [stats.d_p];
bw = 0.5; % bin width, um
plot_histogram(d, bw, 'LogNormal');