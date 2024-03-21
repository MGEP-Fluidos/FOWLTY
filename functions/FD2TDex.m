function [Kex] = FD2TDex(w, Fex, T)
% Purpose:  
%     Calculation of excitation force impulse response function 
%     in time domain from frequency domain coefficients
% Inputs :
%     - w       -> Frequency vector
%     - Fex     -> Excitation force vector
%     - Tex     -> Time vector for Kex
% Outputs :
%     - Kex     -> Excitation force inpulse response function

nw = length(w);
dw = w(2)-w(1);
n = length(T);
Kex = zeros(n,1);
for j = 1:n
    for k = 1:nw
        Kex(j,1) = Kex(j,1)+real(Fex(k)*exp(1i*w(k)*T(j)))*dw;
    end
end
Kex = Kex/(pi);
    
    
    
%     figure;
%     plot(T,Kex,'r');
%     xlabel('Time (s)');
%     ylabel('Force retardation function');
end