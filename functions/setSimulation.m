function [turb,wind] = setSimulation(SimulinkModel,WindCase)
%%     Load simulink file to read parameters from the farm
    load_system([SimulinkModel '.mdl'])
    wind            = get_param([SimulinkModel '/Wind Field/Ambient Field'],'UserData');
    turb            = get_param([SimulinkModel '/Wind Field/Wake1'],'UserData');
    nT              = length(turb.farm.x);
    set_param(SimulinkModel,'ReturnWorkspaceOutputs','off');
    
%%     Load the wind case
    if strcmp(WindCase,'default') == 0 && strcmp(WindCase,'Default') == 0 && strcmp(WindCase,'DEFAULT') == 0
        windL = load([WindCase '.mat']);
        update_windfield_name(WindCase,SimulinkModel);
        
        % Change parameters if new wind is different from the previous one
        if windL.wind.Ts ~= wind.Ts
            set_param([SimulinkModel '/Wind Field/CTrate'],'OutPortSampleTime',num2str(windL.wind.Ts));
            for i = 1:nT
                wp      = get_param([SimulinkModel '/Wind Field/Wake' int2str(i)],'UserData');
                wp.ts   = windL.wind.Ts;
                set_param([SimulinkModel '/Wind Field/Wake' int2str(i)],'UserData',wp);
                for j = 1:nT
                    if min(turb.farm.x(i) - turb.farm.x(j),0) < 0
%                         set_param([SimulinkModel '/Wind Field/Wake' int2str(i) '/WCDelay' int2str(j)],'samptime',int2str(windL.wind.Ts));
%                         set_param([SimulinkModel '/Wind Field/Wake' int2str(i) '/aDelay' int2str(j)],'samptime',int2str(windL.wind.Ts));
                        set_param([SimulinkModel '/Wind Field/Wake' int2str(i) '/WCDelay' int2str(j)],'samptime',sprintf('%.2f',wind.Ts));
                        set_param([SimulinkModel '/Wind Field/Wake' int2str(i) '/aDelay' int2str(j)],'samptime',sprintf('%.2f',wind.Ts));
                    end
                end
            end
        end
        if windL.wind.Umean ~= wind.Umean
            delays = zeros(nT);
            for i = 1:nT
                for j = 1:nT
                    dis = min(turb.farm.x(i)-turb.farm.x(j),0);                             % Distance (in x axis) from j to i
                    if dis < 0      % Downwind turbines
                        delays(i,j) = round(abs(dis/(windL.wind.Umean*windL.wind.Ts)));     % Delay in time steps
                        set_param([SimulinkModel '/Wind Field/Wake' int2str(i) '/WCDelay' int2str(j)], ...
                                   'NumDelays',int2str(delays(i,j)));                       % Update wind center delay block
                        set_param([SimulinkModel '/Wind Field/Wake' int2str(i) '/aDelay' int2str(j)], ...
                                   'NumDelays',int2str(delays(i,j)));                       % Update deficit delay block
                    else            % Upwind turbines
                        delays(i,j) = 0;
                    end
                end
            end
        end
        wind = get_param([SimulinkModel '/Wind Field/Ambient Field'],'UserData');
    end
end

