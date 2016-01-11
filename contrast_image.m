function I_out = contrast_image(I_in, C)

% applies a tanh function to contrast the greyscale image
% C can be used to increase or decrease the contrast

[n, m] = size(I_in);
for i=[1:n]
    for j=[1:m]
        s = scale_color(I_in(i,j),C);
        I_out(i,j) = uint8(s*I_in(i,j));
    end
end

function y = scale_color(x,C)
y = C*tanh(10*double(x)/255 - 5) + 1; % value to scale image intensity