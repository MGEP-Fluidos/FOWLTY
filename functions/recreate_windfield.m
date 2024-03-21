function wind = recreate_windfield(windData,opt)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a new wind field realisation based on the parameters in windData.
% Code based on the function create_windfield.m
%
% Author: Yerai Peña-Sanchez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

U0                  = windData.Ua;
Ti                  = windData.Ti;
d                   = windData.d;
Lx                  = windData.Lx;
Ly                  = windData.Ly;
SimTime             = windData.SimTime;

if isfield(windData,'Ts')
    Ts              = windData.Ts;
end

wfgen               = 'Yes';

parallel            = opt.parallel;

while(true)
    % check if the introduced parameters are valid
    error = isempty(U0) || isempty(Ti) || isempty(Lx) || isempty(Ly) || isempty(d) || isempty(SimTime);
    error = error || Ti<0 || Ti>1;
    error = error || U0<=0;
    error = error || Lx<=0 || Ly<=0;
    error = error || d<=0 || d>Lx || d>Ly;
    error = error || SimTime<=0;
    error = error || Ts<=0;
    if(~error)
        h_temp  = gcp;
        h       = h_temp.NumWorkers;
        delete(gcp('nocreate'));
%         h=parpool('size');
        switch(parallel)
            case 'Yes'
                if(h == 0)
                    parpool('open');
                end
            otherwise
                if(h ~= 0)
%                     parpool('close');
                end
        end
        desc = ['Mean:' num2str(U0) ' m/s Turbulence: ' num2str(Ti) ' SimTime:' num2str(SimTime) ];
        wind = gen_windfield(U0,Ti,d,Lx,Ly,SimTime,Ts,desc);
        pause(1)
        if isempty(opt.saveName) == 0
            save(opt.saveName,'wind');
        end
        wfgen = true;
        break;
    end
    err = errordlg('Invalid wind parameters.','Wind Farm Creator');
    uiwait(err);
end

if(~wfgen)
    wind = {};
end
end