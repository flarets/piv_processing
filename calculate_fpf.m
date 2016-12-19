function [fpf] = calculate_fpf(x,y,d_min)
% accepts minimum diameter and returns fraction of particles less than it
n = length(x);
dx = diff(x);

n_total = 0;
for i=1:(n-1)
    n_total = n_total + dx(i)*0.5*(y(i)+y(i+1)); % newton integration
end

n_lessthan_dmin = 0;
for i=1:(n-1)
    if x(i) > d_min; break; end;
    n_lessthan_dmin = n_lessthan_dmin + dx(i)*0.5*(y(i)+y(i+1)); % newton integration
end

fpf = n_lessthan_dmin/n_total;