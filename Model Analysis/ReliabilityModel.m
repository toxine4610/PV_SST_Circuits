
%% PARAMETER SETUP
% membrane constants
tau = 0.020;
R = 3e7;

% resting potential
E = -0.070;
Ee = 0.060;
Ei = -0.080;

% threshold for a spike
theta = -0.040;
% change in time - window
dt = 0.0001; %should be less than tau
% total milliseconds to run for
T = 1.00;
% total number of steps
no_steps = round(T ./ dt);
% time - for plotting
time = linspace(0, T, no_steps + 1);

NumTrials  = 20;

tauE = 10;
tauI = 10;

varE = [5,10,50,100,500,1000];
varI = [5,10,50,100,500,1000];

plotFlag = 1;

for run = 1
    fprintf('Run #%d\n',run);
    %%
    for v = 1
        for w = 1
            
            JitterInh = fix( random('Normal', 1500, varI(2), 1,NumTrials) );
            JitterExc = fix( random('Normal', 500, varE(2),1,NumTrials) );

            AmpInh    =  abs( random('Normal',0.05, 0.03, 1,NumTrials) );
            AmpExc    =  abs( random('Normal',0.1, 0.03, 1,NumTrials) );
            %%
            
            for trial = 1:NumTrials
                
                Spike{trial} = [];
                % voltage matrix
                V = zeros(1, no_steps + 1);
                % initial voltage of membrane - put at rest
                V(1) = -0.07;
                
                % time since last spike
                t_spike = 0;
                % absolute refactory period
                arp = 0.01; %this being 0.02 doesn't work.
                % total number of spikes
                no_spikes = 0;
                
                ge = (tauE.^2).*(time).*exp(-tauE.*(time));
                ge = AmpExc(trial).*ge;
                
                gi = (tauI.^2).*(time).*exp(-tauI.*(time));
                gi = AmpInh(trial).*gi;
                
                gi = circshift( gi,[1,JitterInh(trial)]);
                ge = circshift( ge,[1,JitterExc(trial)]);
                
                for i = 1:no_steps
                    
                    % update without noise
                    dV     = (dt/tau).*( (E-V(i)) + (Ee-V(i)).*ge(i) + (Ei-V(i)).*gi(i) );
                    V(i+1) = V(i) + dV;
                    
                    % Spiking mechanism ...................................................
                    if (V(i+1) > theta)
                        if no_spikes>0
                            % check we're not in absolute refac period
                            if (time(i)>=(t_spike+arp))
                                % reset voltage
                                V(i+1) = E;
                                % Eleni's trick of making spikes look nice
                                V(i) = -0;
                                % record spike
                                t_spike = time(i);
                                % increment spike count
                                no_spikes = no_spikes+1;
                                Spike{trial} = [Spike{trial}, t_spike];
                            end
                        else
                            % no spikes yet - no need to check
                            V(i+1) = E;
                            % Eleni's trick of making spikes look nice
                            V(i) = -0;
                            % record spike
                            t_spike = time(i);
                            Spike{trial} = [Spike{trial}, t_spike];
                            % increment spike count
                            no_spikes = no_spikes+1;
                        end
                    end;
                end;
                if plotFlag
                    figure(v);
                    subplot(1,2,2);
                    plot( time, ge,'b','linewidth',3); hold on;
                    plot( time, gi,'r','linewidth',3); hold on;
                    axis square; box off;
                    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
                end;
            end;
            
            
            if plotFlag
                for trial = 1:NumTrials
                    figure(v); set(gcf,'color','w')
                    subplot(1,2,1);
                    for n = 1 : size(Spike{trial},2)
                        plot( Spike{trial}(n), trial, 'o','markersize',10,'markerfacecolor','k','markeredgecolor','k');
                        hold on;
                        axis square; box off;
                        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
                    end;
                end;
            end;
            
            indx = find(~cellfun(@isempty,Spike));
            ct = 0;
            for trial = indx
                ct = ct+1;
                STJitter(ct) = abs( Spike{trial}(1) - Spike{indx(1)}(1) );
            end;
            
            [Reliab(run,v,w), ~] = computeModelRel(Spike,time);
            AveJitter(v) = mean(STJitter(2:end));
            
        end;
    end;
end;

%%
figure(1); set(gcf,'color','w');
R = squeeze(Reliab);
stdshadenew( (varI), mean(R,1), std(R,1)./sqrt(15),1,'b')
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);



%         figure(300);
%         plot(varE, Reliab,'-o','markersize',12,'markerfacecolor','r','markeredgecolor','r');
%         hold on;
%         axis square; box off;
%         
%         Jitter(run,:) = AveJitter;