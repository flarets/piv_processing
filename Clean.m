clc; clear; 
close all;
warning off;

% set calibration constant
constant = 0; % calculate

% -----------------------------------
% Read image

path = '';
fname = 'piv_image.csv';
ifname = sprintf('%s\\%s',path,fname);
I2 = csvreadfile(ifname);

% -----------------------------------
% Noise filters

% use 6th order butterworth filter to remove noise
% f_c = 0.98; % cutoff frequency
% I2 = butterworth_noise_filter(I2,f_c);
I3 = gpuArray(I2);

% % increase contrast using linear function
% threshold = 2e3;
% I3 = I2>threshold;
% I3 = contrast_image(I3,threshold,60e3);

% matlab contrast function
t_range = 2^16-1;
t_min = 2000;
t_max = t_range;
I3 = imadjust(I3,[t_min/t_range; t_max/t_range],[0;1]);

% create binary
I_bin = I3 > 2500;

% Detect edges and fill to create binary image
% I4 = edge(I3, 'canny', 0.1);
% I_bin = imfill(I4, 'holes'); % fill 'holes'
% I_bin = logical(I5 - I4); % subtract 'edges' from 'filled holes'

% figure();
% ax(1) = subplot(1,2,1);
% imshow(I2)
% title('original image');
% ax(2) = subplot(1,2,2);
% imshow(I3);
% title('before and after contrasting');
% linkaxes(ax,'xy');

% -----------------------------------
% Get particle data from noise-reduced and binary images

% extract particle data from image
[stats] = process_image(I_bin, I3);

% Filter particles less than 1px
p_min = 0;  % px
p_max = 50; % px
[stats] = filter_pixel_size(stats, p_min, p_max);

% find intensity-weighted mean diameter in pixels and scale data
d = [stats.d_e]; % diameters, px
dp_m = 10; % known mean diameter, um
bw = 0.01; % bin width, px
hist_type = 'lognormal';
[de_m, h] = plot_histogram(d, bw, hist_type);
% close();

% if not set, calculate constant in um/px
if constant == 0
    constant = (dp_m/de_m); % calibration constant, um/pixel
end
fprintf('calibration constant = %g\n', constant);
[stats] = scale_data(stats, constant);

% -----------------------------------
% Filter particle data

% % Filter based on diameter, um
% d_min = 0;  % um
% d_max = 500; % um
% [stats] = filter_size(stats, d_min, d_max);
% 
% % Filter based on skewness
% a_min = 0.6;
% a_max = 1/0.6;
% [stats] = filter_asym(stats, a_min, a_max);

% -----------------------------------
% Plot particle data

% plot original image
figure()
imshow(I2,'InitialMagnification','fit');
title(sprintf('original image: %s', ifname));

% plot grayscale image, thresholded image, filtered image with identified particles
figure();
ax(4)=subplot(2,2,1);
imshow(I3,'InitialMagnification','fit');
title('contrasted image');

ax(1)=subplot(2,2,2);
imshow(I3,'InitialMagnification','fit');
title('noise removal and threshold');

ax(2)=subplot(2,2,3);
imshow(I_bin,'InitialMagnification','fit');
hold on;
% C = reshape([stats.WeightedCentroid],2,length(stats))'; % particle centroids
C = cat(1, stats.WeightedCentroid);
plot(C(:,1), C(:,2), 'bx');
hold off;
title('binary image and centroids');

ax(3) = subplot(2,2,4);
imshow(I2,'InitialMagnification','fit');
hold on;
radii = 0.5*[stats.d_e]; % particle radii
viscircles(C,radii);
DX = cat(1, stats.sig_x);
DY = cat(1, stats.sig_y);
errorbarxy(C(:,1),C(:,2),DX,DY,{'r+','r','r'});
hold off;
title('original image with identified particles');

linkaxes(ax,'xy'); % link axes

d = [stats.d_p];
bw = bw*constant; % bin width, um
[dp_m, h] = plot_histogram(d, bw, hist_type);
axis([0 50 0 inf]);

% Fine Particle Fraction
d_min = 5;
FPF = FPF(h(2).XData, h(2).YData, d_min);

fprintf('mean particle diameter = %gum\n', dp_m);
fprintf('FPF <%ium = %4.2f%%\n', d_min, FPF*100);

