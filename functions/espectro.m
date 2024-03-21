function [t,f,Y]=espectro(y,Fs)
% [t,f,Y]=espectro(y,Fs)
% y: signal
% Fs: Sample rate
% t: signal time
% Y: Signal Fourier Spectrum
T = 1/Fs;
L = length(y);
t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Y = fft(y,NFFT)/L;
Y=Y(1:NFFT/2+1);
f = Fs/2*linspace(0,1,NFFT/2+1);
