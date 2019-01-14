function plotOriTuning

warning('off')
addpath('../Build Data/');
addpath('../Reliabilty Analysis/');
addpath('HotellingT2/');
% close all;
%%
Filepath   = '../Data Repository/SOM-ChR2/MouseTG4/';
ExpDate    = '24-May-2016/';
ExpName    = 'Opto1/';
load( [Filepath ExpDate ExpName 'Ori.mat'] );
%% make tuning curve.
plotFlag   = 1;
rasterFlag = 0;
fprintf('Processing %d cells\n', Ori.numCells);
for n = 1:Ori.numCells
    % figure(n*100); plot( linspace(0,810,32400),Ori.dFF(n,:),'color','k'); hold on;
    % figure(n*100); plot( linspace(0,810,32400),10*Ori.Spks(n,:),'color','r'); hold off;
    if Ori.SamplRate == 20
        indxON  = 81:120;
        indxOFF = 1:80;
    elseif Ori.SamplRate == 10
        indxON = 41:60;
        indxOFF = 1:40;
    end;
    NumOrient   = 16;
    Angles      = 0:22.5:337.5;
    
    ct = 0;
    for ori = 1:NumOrient
        ct = ct+1;
        foo = Ori.SpkResponse{n}{ori};
        foo = foo';
        ON  = foo(:, indxON);
        OFF(ori) = mean( mean(foo(:, indxOFF),1) );
        if ori == 5
            muONVec = mean(ON(2:2:end),1); % average over trials.
        else
            muONVec = mean(ON,1); % average over trial
        end;
        if rasterFlag
            figure(100+n); set(gcf,'color','w');
            subplot(4, 4, ct);
            stdshadenew( linspace(-2,4,120), mean(foo,1), std(foo,[],1)./sqrt(6),0.2,'k');
            line([2,2],[0,4],'linestyle','--','color','r'); hold on;
            axis square; box off; xlim([-2,4]); ylim([0,4]);
            drawnow;
        end;
        muONVal(ori) = mean(muONVec); % average over time;
        sONVec =  mean(ON,2); % average over trials.
        sdONVal(ori) = std(sONVec);
        On = mean(ON,2);
%         P(n) = T2Hot1(On);
    end;
    
    TC = muONVal;
    [CoeffSet,R2] = FitTCFull(TC);
    Ors = linspace(0,337.5,200000);
    Ori.OrFit(n,:) = VonMisesFuntionNew(CoeffSet,Ors*(pi/180));
    Ori.Width(n) = extractTuningWidth(CoeffSet);
    Ori.OrFitCoeffs{n} = CoeffSet;
    Ori.OrFitQuality(n)= R2;
    Ori.Matrix{n}   = muONVal;
    F0_mean = VonMisesFuntionNew(CoeffSet,Angles*(pi/180));
    [OSI, PrefOri] = CalculateOSI( F0_mean );
    OI = empiricalOI(F0_mean);
    Ori.OI(n)  = OI;
    Ori.OSI(n) = OSI;
    Ori.BestOSI(n) = max(OI,OSI);
    if PrefOri > 180
         Ori.PrefOri(n) = PrefOri - 180;
    else
         Ori.PrefOri(n) = PrefOri;
    end;

    disp([n Ori.OrFitQuality(n) max(Ori.OSI(n),OI) Ori.PrefOri(n) Ori.Width(n)]);
    
    if plotFlag
         if ismember(n,Ori.cell2keep)
             clr = 'b';
         else
             clr = 'g';
         end;
        figure(n); set(gcf,'color','w');
        subplot(1,2,1);
        errorbar( Angles, muONVal, sdONVal./sqrt(10),'o','color','k','linewidth',3,...
                  'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
        plot(Angles, mean(mean(OFF))*ones(1,length(Angles)),'color','r');
        axis square; box off;
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        xlim([0, 360]); set(gca,'xtick',0:90:360); xlim([-20,360]);
        plot( Ors, Ori.OrFit(n,:),'color',clr,'linewidth',3);
        
        subplot(1,2,2);
        p=polar( Angles.*(pi/180), muONVal,'k'); hold on;
        set(p(1),'linewidth',3);
        p=polar( Angles.*(pi/180), muONVal+sdONVal./sqrt(10),'--k');
        set(p(1),'linewidth',1);
        p=polar( Angles.*(pi/180), muONVal-sdONVal./sqrt(10),'--k');
        set(p(1),'linewidth',1);
        axis square; box off;
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        drawnow
%         end;
    end;
end;

%% save
save( [Filepath ExpDate ExpName 'Ori.mat'],'Ori' );