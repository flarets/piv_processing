function [np, mean_dia] = calc_threshold(I1, threshold_range, md)

n = length(threshold_range);
np = zeros(n); % array of number of detected particles 
mean_dia = zeros(n); % array of mean particle diameter

for i = 1:n
    threshold = threshold_range(i);
    [stats] = process_image(I1,threshold,md);
    
    % Filter based on diameter, um
    d_min = 0.1;  % um
    d_max = 50; % um
    [stats] = filter_size(stats, d_min, d_max);

    np(i) = length(stats);
    mean_dia(i) = mean([stats.d_e]);
end

figure();
subplot(2,1,1)
hold on;
grid on;
xlabel('threshold');
ylabel('number of particles');
plot(threshold_range, np, 'r');

subplot(2,1,2)
hold on;
grid on;
axis([0 72 0 3]);
xlabel('threshold');
ylabel('mean intensity-weighted diameter, px');
plot(threshold_range, mean_dia)