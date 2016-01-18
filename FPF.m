function [fine_particle_fraction] = FPF(stats,d_min)
% accepts minimum diameter and returns fraction of particles less than
% d_min
% (n<d_min)/n
n = length(stats);

largerparticles = [];
for i=1:length(stats)
    if (stats(i).d_p >= d_min)
        largerparticles = [largerparticles, i]; % indicies to remove
    end
end
stats(largerparticles) = [];

n_lessthan_dmin = length(stats);

fine_particle_fraction = (n_lessthan_dmin)/n;