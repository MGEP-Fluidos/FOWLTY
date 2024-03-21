function [eta,fe_vec,timevec,fnin,Hs2i] = whitenoiseWave(dt,t_max,Hs,Tw,wfreq,Fesys,turb,nT,DD)

[nF,~]                  = size(Fesys);

if nF == length(wfreq) 
    Fesys               = Fesys.';
    [nF,~]              = size(Fesys);
end

Fs                      = 1/dt;
Nl                      = ceil(t_max*Fs);

rng(DD)
s                       = 1;
nin                     = s*Hs*randn(Nl,1);
[~,fnin,NIN]            = espectro(nin,Fs);
w                       = 2*pi*fnin;

[~,Hs2i,~,~]            = JONSWAP(w,Tw,Hs,3.3);
feCoeff                 = interp1(wfreq.',Fesys.',w,'linear');
    
feCoeff(isnan(feCoeff)) = 0;

[t_1,t_2]               = size(feCoeff);
if t_2 > t_1
    feCoeff             = feCoeff.';
end

feCoeff_abs             = abs(feCoeff);
feCoeff_ang             = angle(feCoeff);
k                       = zeros(length(w),nT);
fe                      = [];
for j = 1:nT
    k(:,j)              = (turb.farm.x(j)-turb.farm.x(1))*((w.^2)/9.81);
    for i = 1:nF
        feCoeffNew(:,i) = feCoeff_abs(:,i).*cos(feCoeff_ang(:,i)+k(:,j)) + feCoeff_abs(:,i).*sin(feCoeff_ang(:,i)+k(:,j))*1i;
    end
    Fspe                = NIN.'.*Hs2i.*feCoeff.';
    Wspe                = NIN.'.*Hs2i;
    
    [eta,timevec]       = fftInvertion(Wspe,dt,t_max);
    
    fe_t                = [];
    for i = 1:nF
        Fspe_l          = Fspe(i,:);
        [forcG_l,~]     = fftInvertion(Fspe_l,dt,t_max);
        fe_t(i,:)       = forcG_l;
    end
    
    cte                 = Hs/(4*std(eta));
    eta                 = eta.'*cte;
    fe                  = [fe fe_t.'*cte];

end

[t_1,t_2]               = size(timevec);
if t_1 < t_2
    timevec             = timevec.';
end

fe_vec                  = [timevec fe];            % Wave excitation force vector for simulink


