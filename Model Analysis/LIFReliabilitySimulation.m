function [Reliab_Inhib, Reliab_Exc, Reliab_Output, Spike] = LIFReliabilitySimulation(Number_Exc_Clusters , Number_Inh_Clusters)

%% PARAMETER SETUP

%Number of neurons
NExc = 800;
NInh = 200;

% neuron params. Voltages in V, time in s
tau = 20e-3;
R   = 3e7;

Erest = -70e-3;
Ee    =  0e-3;
Ei    = -70e-3;

Threshold = -40e-3;
Reset     = -70e-3;

% integration params.
dt =  10e-5;
TotalSimTime = 2.00;

% total number of steps
no_steps = round(TotalSimTime ./ dt);
% time - for plotting
time = linspace(0, TotalSimTime, no_steps + 1);


%% Inh. and Exc. Conductance kernels.
tauE = 15;
tauI = 15;
delay = 5;
KerTime = linspace(0,1,50);

ge = (tauE.^2).*(KerTime).*exp(-tauE.*(KerTime));
gi = (tauI.^2).*(KerTime).*exp(-tauI.*(KerTime));
gi = circshift(gi,[1,delay]);

figure(1); set(gcf,'color','w');
plot( KerTime, ge,'color','b','linewidth',3); hold on;
plot( KerTime, gi,'color','r','linewidth',3); hold on;
axis square;  box off; axis off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')

%%

for runNumber = 1:40
%% Network params
Number_Exc_Clusters = 100; % <--- This number determines the reliability of the input
Number_Inh_Clusters = 10;  % <--- This number determines the reliability of the input
RateExc  = 0.1;
RateInh  = 0.2;
NumTrials = 20;

%%
for trial = 1:NumTrials
    clear Inh Exc AmpInh AmpExc InputExc InputInh
    V = zeros(1, no_steps + 1);
    V(1) = -70e-3;
    Spike{trial} = [];
    
    [Inh, Exc] = generatePoissonInputs(NExc, NInh, Number_Exc_Clusters,Number_Inh_Clusters,RateExc,RateInh, time, no_steps);
    
    AmpInh    =  abs( random('Normal',0.05, 0.03, 1, NInh) );
    AmpExc    =  abs( random('Normal',0.1,  0.03, 1, NExc) );
    
    for n = 1:NExc
        ExcG(n,:) = AmpExc(n).*conv(Exc(n,:),ge,'same');
    end;
    
    for n = 1:NInh
        InhG(n,:) = AmpInh(n).*conv(Inh(n,:),gi,'same');
    end;
    
    % voltage matrix
    V = zeros(1, no_steps + 1);
    V(1) = -70e-3;
    t_spike = 0;
    arp = 0.01;
    no_spikes = 0;
    
    InputInh = mean(InhG,1);
%     InputInh = InputInh./max(InputInh);
    InputExc = mean(ExcG,1);
    InputExc = mean(ExcG,1) + (1.48*(mean(InputExc)) - mean(InputInh));
%     InputExc = InputExc./max(InputExc);
    
    for i = 1:no_steps
        
        % update without noise

        
        dV     = (dt/tau).*( (Erest-V(i)) + (Ee-V(i)).*(InputExc(i)) + (Ei-V(i)).*(InputInh(i)) );
        V(i+1) = V(i) + dV;
        
        % Spiking mechanism ...................................................
        if (V(i+1) > Threshold)
            if no_spikes>0
                % check we're not in absolute refac period
                if (time(i)>=(t_spike+arp))
                    % reset voltage
                    V(i+1) = Erest;
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
                V(i+1) = Erest;
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
    
    figure(200+runNumber); set(gcf,'color','w');
    subplot(5,4,trial)
    plot(time, V); hold on; 
    axis square; box off;
    drawnow
   InhibInput{trial} = InputInh;
   ExcInput{trial} = InputExc;
end;


for trial = 1:NumTrials
    figure(500+runNumber); set(gcf,'color','w')

    for n = 1 : size(Spike{trial},2)
        plot( Spike{trial}(n), trial, 'o','markersize',10,'markerfacecolor','k','markeredgecolor','k');
        hold on;
        axis square; box off;
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    end;
    
end;

[Reliab_Inhib(runNumber), Reliab_Exc(runNumber)] = computeInputRel(InhibInput, ExcInput);
[Reliab_Output(runNumber), ~] = computeModelRel(Spike,time);
end;

