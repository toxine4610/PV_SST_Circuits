function populationTuningCurve(Ori)

Angles = 0:22.5:337.5;
 bestCells = Ori.numCells;
% bestCells  = intersect( find(Ori.OrFitQuality>60), Ori.cell2keep);
for n   = 1: length(bestCells)
    Stim = [];
    foo = Ori.SpkResponse{bestCells(n)};
    for ori = 1:16
        
%         if ori == 5
%             Stim  = [Stim; nanmean( foo{ori}(81:120, 1:2:10),2)];
%         else
            Stim  = [Stim; nanmean( foo{ori}(81:120, :),2)];
%         end;
        
    end;
    X(n,:) = Stim';
end;

muStim = mean(X,1);
muStim = reshape(muStim,40,16);

PopTC  = mean(muStim,1);
[CoeffSet,R2] = FitTCFull(PopTC);
Ors   = linspace(0,337.5,200000);
OrFit = VonMisesFuntionNew(CoeffSet,Ors*(pi/180));


F0_mean = VonMisesFuntionNew(CoeffSet,Angles*(pi/180));
[OSI, PrefOri] = CalculateOSI(F0_mean);
OI = empiricalOI(F0_mean);

% if PrefOri > 180
%     PrefOri = PrefOri - 180;
% else
%     PrefOri = PrefOri;
% end;

disp( [R2 max(OSI,OI) PrefOri] );

figure(1); set(gcf,'color','w');
plot( 0:22.5:337.5, PopTC,'-','color','k','linewidth',3,...
    'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
xlim([0, 360]); set(gca,'xtick',0:90:360); xlim([-20,360]);
plot( Ors, OrFit,'r','linewidth',3);
drawnow