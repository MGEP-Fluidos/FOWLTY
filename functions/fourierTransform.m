function output = fourierTransform(data_vector, time_vector)

dt          = time_vector(2) - time_vector(1);          % Time discretization
fs          = 1/dt;                                     % Frequency rate
T           = time_vector(end) - time_vector(1);        % Fundamental period
w0          = 2*pi/T;                                   % Fundamental frequency (rad/s)
f0          = w0/(2*pi);                                % Fundamental frequency (Hz)
N_samples   = floor(fs/f0);                             % Sample number
time_v      = time_vector(1) + (1/fs)*(0:N_samples);    % Reconstructed time vector

L           = length(time_v);                           % Signal length
X           = fft(data_vector,L);                       % Double-sided Fourier transform
Xs          = X(1:floor(L/2));                          % Single-sided Fourier transform
Xs          = Xs/floor(L/2);                            % Integral scaling

%mag_Xs      = abs(Xs);                                  % Magnitude of FFT
%pha_Xs      = phase(Xs);                                % Phase of FFT

f_fft       = (0:L/2-1)*fs/L;                           % Double-sided frequency vector (Hz)
f_Xs        = f_fft(1:floor(L/2));                      % Single-sided frequency vector (Hz)
w_Xs        = 2*pi*f_Xs;                                % Single-sided frequency vector (rad/s)

Y           = ifft(X);                                  % Complex time-domain reconstruction of signal
Yr          = real(Y);                                  % Real time-domain reconstruction of signal

%error       = 1 - goodnessOfFit(Yr.', data_vector.', 'NRMSE');
error = [];

% Output structure --------------------------------------------------------
output.transform = Xs;
output.frequency = w_Xs;
output.time      = time_v;
output.signal    = Yr;
output.error     = error;
% -------------------------------------------------------------------------

end