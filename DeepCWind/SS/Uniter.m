clearvars

load DeepCWind_Markel.mat

sys11 = load('sys11.mat');
sys22 = load('sys22.mat');
sys33 = load('sys33.mat');
sys12 = load('sys12.mat');
sys13 = load('sys13_4.mat');
sys23 = load('sys23_4.mat');

sys11 = passivise(balancmr(sys11.sysr,4));
sys22 = passivise(balancmr(sys22.sysr,4));
sys33 = passivise(balancmr(sys33.sysr,4));
sys12 = sys12.sysr;
sys13 = passivise(balancmr(sys13.sysr,4));
sys23 = sys23.sysr;

% % % Considering all the DoFs and interactions (surge, heave, and pitch)
% Ar = blkdiag(sys11.a,sys12.a,sys13.a,sys12.a,sys22.a,sys23.a,sys13.a,sys23.a,sys33.a);
% Br = [blkdiag(sys11.b,sys12.b,sys13.b);blkdiag(sys12.b,sys22.b,sys23.b);blkdiag(sys13.b,sys23.b,sys33.b)];
% Cr = blkdiag([sys11.c sys12.c sys13.c],[sys12.c sys22.c sys23.c],[sys13.c sys23.c sys33.c]);

% % % Considering no interactions with heave
% Ar = blkdiag(sys11.a,sys13.a,sys22.a,sys13.a,sys33.a);
% Br = [blkdiag(kron([1 0],sys11.b),sys13.b);kron([0 1 0],sys22.b);blkdiag(kron([1 0], sys13.b),sys33.b)];
% Cr = blkdiag([sys11.c sys13.c],sys22.c,[sys13.c sys33.c]);

% % % Not considering heave (only surge and pitch)
DoF = [1 3];
Ar  = blkdiag(sys11.a,sys13.a,sys13.a,sys33.a);
Br  = [blkdiag(sys11.b,sys13.b);blkdiag(sys13.b,sys33.b)];
Cr  = blkdiag([sys11.c sys13.c],[sys13.c sys33.c]);

sysRad = ss(Ar,Br,Cr,0);
sysRad = balancmr(sysRad,8);

return

%% Compare
clear sys11 sys22 sys33 sys12 sys13 sys23 Ar Br Cr

Mu      = Mu(DoF,DoF);
A       = A(DoF,DoF,:);
B       = B(DoF,DoF,:);

Fe      = Fe(:,DoF);
K_rad   = K_rad(DoF,DoF,:);
Mass    = Mass(DoF,DoF);

for i = 1:length(w)
    Z(:,:,i) = B(:,:,i) + complex(0,w(i)).*(A(:,:,i)-Mu);
end

nDoF  = length(DoF);
for i = 1:nDoF
    for ii = 1:nDoF
        fresp_temp = squeeze(Z(i,ii,:));
        Z_temp = frd(fresp_temp,w);
        ZF(i,ii) = Z_temp;
    end
end

bode(ZF); hold on
bode(sysRad)

clear i ii fresp_temp Z Z_temp ZF
% return

%% Create whole system SS
nR      = length(sysRad.a);

K_moo   = [7.08e4   0      -1.08e5; ...
           0        1.91e4  0     ; ...
           -1.07e5  0       8.73e7];        % From the report "Definition of the Semisubmersible Floating System for Phase II of OC4"
K_moo   = K_moo(DoF,DoF);
Kh      = Kh(DoF,DoF);

B_drag  = diag([3.95e5,3.88e6,3.7e10]);       % From the report "Definition of the Semisubmersible Floating System for Phase II of OC4"
B_drag  = B_drag(DoF,DoF);

MassMu  = pinv(Mass+Mu);

Ass_t   = kron(eye(nDoF),[0 1; 0 0])+...
          kron(MassMu*(K_moo+Kh),[0 0;-1 0])+...
          kron(MassMu*B_drag,[0 0;0 -1]);
Bss_t   = kron(MassMu,[0;1]);
CssV_t  = kron(eye(nDoF),[0 1]);

Ass     = [Ass_t Bss_t*sysRad.c ; sysRad.b*CssV_t sysRad.a];
Bss     = [Bss_t ; zeros(nR,nDoF)];
CssP    = [kron(eye(nDoF),[1 0]) zeros(nDoF,nR)];
CssV    = [CssV_t zeros(nDoF,nR)];
CssPV   = [eye(2*nDoF) zeros(2*nDoF,nR)];

sysPlat = ss(Ass,Bss,CssPV,0);

clear Ass_t Bss_t CssV_t Ass Bss CssV CssP CssPV MassMu B_drag K_moo nR nDoF
save('DeepCWind.mat')


