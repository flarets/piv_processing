function [] = plot_particles_vs_threshold()

% reads 'data.txt' and plots first two columns.
% in this case, we expect these columns to correspond to
% number of particles found vs threshold value

x = []; % threshold value
y1 = []; % number of particles found
y2 = []; % mean particle diameter

% read file and store data as arrays
fin = fopen('data.txt','r');
while true
    line = fgetl(fin);
    if (line == -1)
        break;
    end
    data = str2num(line);
    x = [x, data(1)];
    y1 = [y1, data(2)];
    y2 = [y2, data(3)];
end
fclose(fin);

