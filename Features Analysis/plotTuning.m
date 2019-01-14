function plotTuning(Filepath, ExpDate, ExpName)
warning('off')
addpath('../Build Data/');
addpath('../Reliabilty Analysis/');
close all;
%%
% Filepath   = '../Data Repository/PV-Animals/PV-K/';
% ExpDate    = '4-Dec-2014/';
% ExpName    = 'Nat1/';
load( [Filepath ExpDate ExpName 'Grat.mat'] );
%% make tuning curve.
plotFlag   = 1;
rasterFlag = 0;
fprintf('Processing %d cells\n',Grat.numCells);
for n = 1:Grat.numCells
%     
    % figure(n*100); plot( linspace(0,810,32400),Grat.dFF(n,:),'color','k'); hold on;
    % figure(n*100); plot( linspace(0,810,32400),10*Grat.Spks(n,:),'color','r'); hold off;
    indxON  = 41:120;
    indxOFF = 1:40;

    NumSpatFreq = 9;
    NumOrient   = 5;
    Angles  = linspace(0, 180, NumOrient);
    SpatInc = [0, 0.002*2.^(0:NumSpatFreq-2)];
    
    Grat.Angles = Angles;
    Grat.SpatInc = SpatInc;
    
    ct = 0;
    for ori = 1:5
        for sf = 1:9
            ct = ct+1;
            foo = Grat.SpkResponse{n}{ori, sf};
            foo = foo';
            ON  = foo(:, indxON);
%             ON  = foo(:, indxON) - repmat(mean( foo(:,indxOFF), 2),1,length(indxON));
            OFF(ori,sf) = mean( mean(foo(:, indxOFF),1) );
            muONVec = mean(ON,1); % average over trials.
            if rasterFlag 
                figure(100+n); set(gcf,'color','w');
                subplot(5, 9, ct);
                stdshadenew( linspace(-2,4,120), mean(foo,1), std(foo,[],1)./sqrt(6),0.2,'k');
                line([0,0],[0,4],'linestyle','--','color','r'); hold on;
                axis square; box off; xlim([-2,4]); ylim([0,4]);
            end;
            muONVal(ori,sf) = mean(muONVec); % average over time;
            sONVec =  mean(ON,2); % average over trials.
            sdONVal(ori,sf) = std(sONVec);
        end;
    end;
    
    [~,ind] = max(mean(muONVal,2));
    % Fit SFTC
% %      SFTC = nanmean(muONVal,1);
    SFTC   = muONVal(ind,:);
    BaseLine = mean(mean(OFF));
    [CoeffSet,R2] = fitSFTC(SFTC, BaseLine);
    S = linspace(-9,-2,200000);
    
    Grat.Fit(n,:) = DiffGaussians(CoeffSet,S);
    Grat.PrefSF(n) = 2.^CoeffSet(4);
    Grat.SFFitCoeffs{n} = CoeffSet;
    Grat.SFFitQuality(n)= R2;    
    % Fit OriTC
    [~,ind] = max(mean(muONVal,1));
    TC = muONVal(:,ind);
    [CoeffSet,R2] = FitTC(TC');
    Ors = linspace(0,180,200000);
    Grat.OrFit(n,:) = VonMisesFuntionNew(CoeffSet,Ors*(pi/180));
    
    Grat.OrFitCoeffs{n} = CoeffSet;
    Grat.OrFitQuality(n)= R2;
    Grat.Matrix{n}   = muONVal;
    F0_mean = VonMisesFuntionNew(CoeffSet,Angles*(pi/180));
    [OSI, PrefOri] = CalculateOSI( F0_mean );
    OI = empiricalOI(F0_mean);
    Grat.OI(n)  = OI;
    Grat.OSI(n) = OSI;
    Grat.PrefOri(n) = OSI;
    
    disp([n Grat.SFFitQuality(n) Grat.OSI(n) OI]);
    
    if plotFlag
        figure(n); set(gcf,'color','w');
        subplot(1,3,1); imagesc(SpatInc,Angles, muONVal./max(muONVal(:))); axis square; box off;
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        set(gca,'yticklabels',Angles);set(gca,'xticklabels',SpatInc);
        
        % spatial frequency tuning curve..........................................
        subplot(1,3,2); set(gcf,'color','w');
        errorbar( SpatInc, nanmean(muONVal,1), nanstd(muONVal,[],1)./sqrt(5),'o','color','k','linewidth',3,...
            'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
        plot( SpatInc, mean(mean(OFF))*ones(1,length(SpatInc)),'color','r');
        axis square; box off; set(gca,'xscale', 'log');
        set(gca,'xtick',SpatInc,'xticklabels',[]); xlim([-0.001, 0.3]);
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        plot( 2.^S, Grat.Fit(n,:),'r','linewidth',3);
    end;
    
    % orientation tuning curve.................................................
    if plotFlag
        subplot(1,3,3); errorbar( Angles, muONVal(:,ind), sdONVal(:,ind)./sqrt(9),'o','color','k','linewidth',3,...
            'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
        plot(Angles, mean(mean(OFF))*ones(1,length(Angles)),'color','r');
        axis square; box off;
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        xlim([0, 180]); set(gca,'xtick',0:45:180); xlim([-20,200]);
        plot( Ors, Grat.OrFit(n,:),'r','linewidth',3);
        title([num2str(Grat.OSI(n)) num2str(OI)]);
    end;
    drawnow
end;

%% save
save( [Filepath ExpDate ExpName 'Grat.mat'],'Grat' );