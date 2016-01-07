function [im,I3,circles] = processim(original_image,threshold,maxR)
% Variables
origim = original_image;
minR = 1;
thresh = 0.33;
delta = 12;

% Convert to grayscale
im=rgb2gray(original_image);

% Threshold image to binary
I3=im>threshold;

% Create a 3D Hough array with the first two dimensions specifying the
% coordinates of the circle centers, and the third specifying the radii.
% To accomodate the circles whose centers are out of the image, the first
% two dimensions are extended by 2*maxR.
maxR2 = 2*maxR;
hough = zeros(size(im,1)+maxR2, size(im,2)+maxR2, maxR-minR+1);

% For an edge pixel (ex ey), the locations of its corresponding, possible
% circle centers are within the region [ex-maxR:ex+maxR, ey-maxR:ey+maxR].
% Thus the grid [0:maxR2, 0:maxR2] is first created, and then the distances
% between the center and all the grid points are computed to form a radius
% map (Rmap), followed by clearing out-of-range radii.
[X,Y] = meshgrid(0:maxR2, 0:maxR2);
Rmap = round(sqrt((X-maxR).^2 + (Y-maxR).^2));
Rmap(Rmap<minR | Rmap>maxR) = 0;

% Detect edge pixels using Canny edge detector. Adjust the lower and/or
% upper thresholds to balance between the performance and detection quality.
% For each edge pixel, increment the corresponding elements in the Hough
% array. (Ex Ey) are the coordinates of edge pixels and (Cy Cx R) are the
% centers and radii of the corresponding circles.
edgeim = edge(im, 'canny', [0.15 0.2]);
[Ey,Ex] = find(edgeim);
[Cy,Cx,R] = find(Rmap);
for i = 1:length(Ex);
  Index = sub2ind(size(hough), Cy+Ey(i)-1, Cx+Ex(i)-1, R-minR+1);
  hough(Index) = hough(Index)+1;
end

% Collect candidate circles.
% Due to digitization, the number of detectable edge pixels are about 90%
% of the calculated perimeter.
twoPi = 0.9*2*pi;
circles = zeros(0,4);    % Format: (x y r t)
for radius = minR:maxR   % Loop from minimal to maximal radius
  slice = hough(:,:,radius-minR+1);  % Offset by minR
  twoPiR = twoPi*radius;
  slice(slice<twoPiR*thresh) = 0;  % Clear pixel count < 0.9*2*pi*R*thresh
  [y,x,count] = find(slice);
  circles = [circles; [x-maxR, y-maxR, radius*ones(length(x),1), count/twoPiR]];
end

% Delete similar circles
% circles = sortrows(circles,-4);  % Descending sort according to ratio
% i = 1;
% while i<size(circles,1)
%   j = i+1;
%   while j<=size(circles,1)
%     if sum(abs(circles(i,1:3)-circles(j,1:3))) <= delta
%       circles(j,:) = [];
%     else
%       j = j+1;
%     end
%   end
%   i = i+1;
% end

if nargout==0   % Draw circles
  figure, imshow(origim), hold on
  for i = 1:size(circles,1)
    x = circles(i,1)-circles(i,3);
    y = circles(i,2)-circles(i,3);
    w = 2*circles(i,3);
    rectangle('Position', [x y w w], 'EdgeColor', 'red', 'Curvature', [1 1])
  end
  hold off
end

end