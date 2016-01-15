function [imageB] = csvreadfile(image)

R1 = 9;
C1 = 0;
data = csvread(image,R1,C1);

% dataA = uint16(gray2ind(data(:,3)));
dataB = uint16(65535*mat2gray(data(:,3)));
% imageA = vec2mat(dataA,2048);
imageB = vec2mat(dataB,2048);

% imageC = imdivide(imageA,imageB);

% Ia = flip(imageA,1);
% Ib = flip(imageB,1);
% Ic = flip(imageC,1);
% figure
% ax(1) = subplot(1,2,1);
% imshow(Ia);

% ax(2) = subplot(1,2,2);
% imshow(imageB);

% ax(3) = subplot(2,2,3);
% imshow(Ic);

% linkaxes(ax,'xy')

% im = image(data(:,1),data(:,2),dataC);

% imshow(data,[0,4095],'InitialMagnification','fit');

% uint8Image = uint8(255 * mat2gray(yourDicomImage));