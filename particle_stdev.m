function [ sig_x,sig_y ] = particle_stdev(X,Y,I)
% accepts I, X, Y data for a particle
% returns sig_x and sig_y for that particle in pixels

sig_x = sqrt((sum(I.*X.^2) - (sum(I.*X)^2/sum(I)))/sum(I));
sig_y = sqrt((sum(I.*Y.^2) - (sum(I.*Y)^2/sum(I)))/sum(I));