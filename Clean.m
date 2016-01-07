% Notes:
%  - imdfindcircles: requires a small radius range (<10px) and works best 
%    for radii >10px. That is, not suitable for these particles.

%% plot image
I1 = imread('PIV 1.44lfry23.000000b.bmp');
plot_image(I1);

%% identify, filter and plot particles, histogram
clc; clear; close all;
% warning('off','all')

I1 = imread('PIV 1.44lfry23.000000b.bmp');
threshold = 25; % 23 results in max particles
md = 10; % known mean diameter, um
[stats,I2,I3] = process_image(I1,threshold,md);

% % Filter based on diameter, um
% d_min = 0;  % um
% d_max = 50; % um
% [stats] = filter_size(stats, d_min, d_max);

% % Filter based on skewness
% a_min = 0.85;
% a_max = 1/0.85;
% [stats] = filter_asym(stats, a_min, a_max);

% plot grayscale image, thresholded image, filtered image with identified particles
figure();
ax(1)=subplot(1,3,1);
imshow(I2,'InitialMagnification','fit');
title('thresholded image');

ax(2)=subplot(1,3,2);
imshow(I3,'InitialMagnification','fit');
title('binary image');

ax(3) = subplot(1,3,3)
imshow(I1,'InitialMagnification','fit');
hold on
C = reshape([stats.WeightedCentroid],2,length(stats))'; % particle centroids
radii = 0.5*[stats.d_e]; % particle radii
viscircles(C,radii);
title('identified particles');

linkaxes(ax,'xy'); % link axes

% plot histogram
d = [stats.d_p];
figure()
h = histogram(d,'BinWidth',0.5,'EdgeColor','r');
xlabel('diameter, \mum');
ylabel('number of particles');

%% plot number of particles and mean diameter vs. threshold
I1 = imread('PIV 1.44lfry23.000000b.bmp');
threshold_range = [0:72];
md = 10; % mean diameter, um
[stats] = calc_threshold(I1, threshold_range, md);

% [FR,FWCX,FWCY,m3]=filter_1_L(0,12,IO2,WCX,WCY);
%% Histogram and Distrubition in micrometres
[RadiiBinCount,FRadiiBinCount]= Dist_1_L(IO2,FR,'Normal',m2,m3);
Dist_1_L(IO2,FR,'LogNormal',m2,m3);
%% Highlight ALL Particles and Idenitfy Filtered
[I4]=PCirc_1_L(I2,WCX,WCY,IO2,FWCX,FWCY,FR);
%% Radius Percentage 
K = PP_F(FRadiiBinCount,10,N);
disp(K)