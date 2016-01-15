function I_out = contrast_image(I_in, g_min, g_max)
% applies a linear function to contrast the greyscale image
% g_min = ?
% g_max = 2^16-1 typ
I_in = gather(I_in); % convert to matlab array

[n, m] = size(I_in);
I_out = zeros(n,m);

for i=[1:n]
    for j=[1:m]
        I_out(i,j) = (fun(I_in(i,j), g_min, g_max));
    end
end
I_out = gpuArray(I_out)

function y = fun(x, g_min, g_max)
% value to scale image intensity
% y = 0.5*100*(tanh(20*double(x)/100 - 5) + 1);
a = 2^16-1;
if x < g_min
    y = 0;
elseif x > g_max
    y = a;
else
    y = (a/(g_max - g_min))*(x - g_min);
end