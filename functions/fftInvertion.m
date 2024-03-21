function [rSt,timeinv] = fftInvertion(Fspe,dt,t_max)
% [rSt,timeinv] = fftInvertion(Fspe,dt,t_max)

Nl = t_max/dt;
f_fSt  = Fspe.';
% f_fSt  = f_fSt.*(fnin.' <= 10 ) + 0.*(fnin.' > 10);
if_fSt = [f_fSt(1:end-1);f_fSt(end-1:-1:1)];
rSt    = real(ifft(if_fSt,'symmetric'));

timeinv  = (0:length(rSt)-1)*dt; 
[~,ddd] = min(abs(timeinv-t_max));
rSt    = (rSt(1:ddd-1))*Nl;
timeinv = timeinv(1:ddd-1);