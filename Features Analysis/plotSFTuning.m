function plotSFTuning
warning('off')
addpath('../Build Data/');
addpath('../Reliabilty Analysis/');
close all;
%%
Filepath   = '../Data Repository/PV-ARCH/Mouse4/';
ExpDate    = '11-Jan-2016/';
ExpName    = 'Opto1/';
load( [Filepath ExpDate ExpName 'Grat.mat'] );
%% make tuning curve.
plotFlag   = 1;
rasterFlag = 0;
fprintf('Processing %d cells\n',Grat.numCells);


for n = 1:Grat.numCells
%     
%     figure(n*100); plot( linspace(0,810,32400),Grat.dFF(n,:),'color','k'); hold on;
%      figure(n*100); plot( linspace(0,810,32400),10*Grat.Spks(n,:),'color','r'); hold off;

    if Grat.SamplRate == 20
        indxON  = 41:120;
        indxOFF = 1:40;
    elseif Grat.SamplRate == 10
        indxON = 21:60;
        indxOFF = 1:20;
    end;

    NumSpatFreq = 9;
    NumOrient   = 3;
    Angles  = [0,45,90];
    SpatInc = [0,0.0025, 0.005, 0.01, 0.02, 0.04, 0.08, 0.16, 0.32];
    
    Grat.Angles = Angles;
    Grat.SpatInc = SpatInc;
    
    ct = 0;
    for ori = 1:NumOrient
        for sf = 1:NumSpatFreq
            ct = ct+1;
            foo = Grat.SpkResponse{n}{ori, sf};
            foo = foo';
            ON  = foo(:, indxON);
            OFF(ori,sf) = mean( mean(foo(:, indxOFF),1) );
            muONVec = mean(ON,1); % average over trials.
            if rasterFlag 
                figure(100+n); set(gcf,'color','w');
                subplot(5, 9, ct);
                stdshadenew( linspace(-2,4,120), mean(foo,1), std(foo,[],1)./sqrt(6),0.2,'k');
                line([0,0],[0,4],'linestyle','--','color','r'); hold on; drawnow
                axis square; box off; xlim([-2,4]); ylim([0,4]);
            end;
            muONVal(ori,sf) = mean(muONVec); % average over time;
            sONVec =  mean(ON,2); % average over trials.
            sdONVal(ori,sf) = std(sONVec);
        end;
    end;
    
    
    % Fit SFTC
     SFTC = max(muONVal);
    
%      [~,ind] = max(mean(muONVal,2));
%      SFTC   = muONVal(ind,:);

    BaseLine = mean(mean(OFF));
    [CoeffSet,R2] = fitSFTC(SFTC, BaseLine);
    ss = log2(SpatInc(2:end));
    S = linspace(ss(1),ss(end),2000);
    
    Grat.Fit(n,:) = DiffGaussians(CoeffSet,S);
    [~,ind]=max(Grat.Fit(n,:));
    Grat.PrefSF(n)  = 2.^S(ind);
    
     if Grat.CorrectionFlag == 1
        Grat.PrefSF(n) = Grat.PrefSF(n)/56.2505;
    end;
    
%     Grat.PrefSF(n) = 2.^CoeffSet(4);
    Grat.SFFitCoeffs{n} = CoeffSet;
    Grat.SFFitQuality(n)= R2;  
   
     disp([n Grat.SFFitQuality(n) Grat.PrefSF(n)]);
    
    if plotFlag
        figure(n); set(gcf,'color','w');
        subplot(1,2,1); imagesc(SpatInc,Angles, muONVal./max(muONVal(:))); axis square; box off;
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        set(gca,'yticklabels',Angles);set(gca,'xticklabels',SpatInc);
        
        % spatial frequency tuning curve..........................................
        subplot(1,2,2); set(gcf,'color','w');
        plot( SpatInc, SFTC, '-o','color','k','linewidth',3,...
             'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
%         errorbar( SpatInc, nanmean(muONVal,1), nanstd(muONVal,[],1)./sqrt(5),'-o','color','k','linewidth',3,...
%             'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
        plot( SpatInc, mean(mean(OFF))*ones(1,length(SpatInc)),'color','r');
        axis square; box off; set(gca,'xscale', 'log');
        set(gca,'xtick',SpatInc,'xticklabels',[]); 
%         xlim([-0.001, 0.32]);
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        plot( 2.^S, Grat.Fit(n,:),'r','linewidth',3);
    end;
    drawnow
end;

%% save
save( [Filepath ExpDate ExpName 'Grat.mat'],'Grat' );