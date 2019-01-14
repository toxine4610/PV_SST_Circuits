
path = ['../Behavior Repository/Pyschometric/'];
MouseID = 'SOM-ChR2-1/';

A = dir( [path MouseID] );
for i = 3:max(size(A))
    Folders{i-2} = A(i).name;
end;


LightUsed  = zeros(size(Folders));
LightUsed(size(Folders,2)-2:size(Folders,2)) = 1;

%%


% Folders = {'01','02','04','05','06','07','08','09','10','11','12','13','14','15','16','17','21','22','23'};
% 29-Jan-2016', '30-Jan-2016','1-Feb-2016','2-Feb-2016','3-Feb-2016','5-Feb-2016','8-Feb-2016','9-Feb-2016'
% Folders = {'1-Feb-2016','3-Feb-2016','9-Feb-2016','10-Feb-2016','11-Feb-2016','12-Feb-2016','8-Feb-2016'};


%%
for i = 1:size(Folders,2)
%     load( ['../Behavior Repository/PV-ChR2-4/' Folders{i} '-Mar-2016/Data.mat'] );
    load([path MouseID Folders{i} '/Data.mat'])

    if LightUsed(i) == 1
       [LickPSTH, LickRatesAve, Timeidx,Stats] = getBehavData(data,1);
       PerCorrect_Light(i) = Stats.PerCorrect_Light;
       PerCorrect_NoLight(i) = Stats.PerCorrect_NoLight;     
       Hits_Light(i)       = sum(Stats.Hits_Light)./sum(Stats.HitOptions_Light);
       Hits_NoLight(i)     = sum(Stats.Hits_NoLight)./sum(Stats.HitOptions_NoLight);
       CR(i)               = sum(Stats.CR)./sum(Stats.CROptions);
       FA(i)               = mean(Stats.FA);
       Lick{i}             = cell2mat( LickPSTH(:,3)' );
       LickRates{i}        = cell2mat( LickRatesAve' );
    elseif LightUsed(i) == 0
       [LickPSTH, LickRatesAve, Timeidx,Stats] = getBehavData(data,0);
       PerCorrect_NoLight(i) = Stats.PerCorrect_NoLight;
       PerCorrect_Light(i) = NaN;
       
       Hits_Light(i)       = NaN;
       Hits_NoLight(i)     = sum(Stats.Hits_NoLight)./sum(Stats.HitOptions_NoLight);
       CR(i)               = sum(Stats.CR)./sum(Stats.CROptions);
       FA(i)               = mean(Stats.FA);
       Lick{i}             = cell2mat( LickPSTH(:,3)' );
       LickRates{i}        = cell2mat( LickRatesAve' );
       PR{i}               = mean(Stats.prob);
       PRerr{i}            = std(Stats.prob);
    end;
end;

%%
figure(100); set(gcf,'color','w');
plot( 1:size(Folders,2), PerCorrect_NoLight, '-o','color','k','linewidth',3,'markersize',18,'markerfacecolor','k','markeredgecolor','k'); hold on;
plot( 1:size(Folders,2), PerCorrect_Light, '-o','color','r','linewidth',3,'markersize',18,'markerfacecolor','r','markeredgecolor','r'); hold on;
box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left');

figure(200); set(gcf,'color','w');
subplot(1,2,1);
plot( 1:size(Folders,2), Hits_NoLight, '-o','color','g','linewidth',3,'markersize',18,'markerfacecolor','g','markeredgecolor','g'); hold on;
%  plot( 1:size(Folders,2), FA, '-o','color','b','linewidth',3,'markersize',18,'markerfacecolor','b','markeredgecolor','b'); hold on;
plot( 1:size(Folders,2), CR, '-o','color','r','linewidth',3,'markersize',18,'markerfacecolor','r','markeredgecolor','r'); hold on;
line( [0,size(Folders,2)+1], [0.7, 0.7],'linestyle','--','color','k')
 box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left');

subplot(1,2,2);
plot( 1:size(Folders,2), FA, '-o','color','b','linewidth',3,'markersize',18,'markerfacecolor','b','markeredgecolor','b'); hold on;
 box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','right');

%%

% figure(300); set(gcf,'color','w');
% plot( 1:size(Folders,2), cell2mat(PR), '-o','color','k','linewidth',3,'markersize',18,'markerfacecolor','k','markeredgecolor','k'); hold on;
% axis square; box off;
% set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left');

% %%
% SmthW=20;
% SmthStd=5;
% 
% OrigLick = LickRates(2);
% OrigLick = cell2mat(OrigLick');
% OrigLick_mean = mean(OrigLick);
% 
% figure(300); set(gcf,'color','w');
% plot( Timeidx, OrigLick_mean,'color','k','linewidth',3); hold on;
% 
% 
% K1Lick = LickRates(3:7);
% K1Lick = cell2mat(K1Lick');
% K1Lick_mean = nanmean(K1Lick);
% 
% figure(300); set(gcf,'color','w');
% plot( Timeidx, K1Lick_mean,'color','g','linewidth',3);


