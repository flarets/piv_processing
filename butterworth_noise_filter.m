function [I3] = butterworth_noise_filter(I2,f_c)

[nx,ny] = size(I2);

Fs = 100; % made up sampling frequency
T = 1/Fs; % sampling period
L = nx*ny; % length of signal
t = (0:L-1)*T; % time vector

X = double(reshape(I2, L, 1)); % signal

% figure()
% plot(t,X)
% title('Noisy signal')
% xlabel('t, s')
% ylabel('color')

Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

% figure()
% plot(f,P1)
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')

[b,a] = butter(6,f_c); % butterworth filter
% figure()
% freqz(b,a);
% title('butterworth filter');

I3 = filter(b,a,X); % filter noise
I3 = uint8(reshape(I3,nx,ny)); % reshape

% figure()
% imshow(I3,'InitialMagnification','fit');
% title('reconfigured image');

