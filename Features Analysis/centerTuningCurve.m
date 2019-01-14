function centerTuningCurve(Ori)


pvColor = [0, 0.45, 0.74];
somColor = [190,30,45]./255;
addpath('../Build Data/');
addpath('../Reliabilty Analysis/');
Ors = linspace(0,337.5,200000);
bestCells  = intersect( find(Ori.OrFitQuality>60), Ori.cell2keep);


for i = 1:length(bestCells)
    
    TC = Ori.OrFit(bestCells(i),:);
    [v,ind] = max(TC);
    if ind>106667
        TCnew = circshift(TC,ind-106667,2);
    else
        TCnew = circshift(TC,106667-ind,2);
    end;
    X(i,:) = TCnew./v;
end;

figure(1); set(gcf,'color','w');
plot( Ors, mean(X), 'color', 'k', 'linewidth', 3); hold on;
plot( Ors, mean(X)+std(X)./sqrt(length(Ori.cell2keep)), 'color', 'k', 'linewidth', 1);
plot( Ors, mean(X)-std(X)./sqrt(length(Ori.cell2keep)), 'color', 'k', 'linewidth', 1);
xlim([0, 360]); set(gca,'xtick',0:90:360); xlim([-20,360]);
ylim([0.35,1]);
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

Orsnew = linspace(0,337.5,200);
Xnew   = spline(Ors,X, Orsnew);


figure(2); set(gcf,'color','w');
stdshadenew(Orsnew,mean(Xnew),std(Xnew)./sqrt(length(Ori.cell2keep)),1,'k');
xlim([0, 360]); set(gca,'xtick',0:90:360); xlim([-20,360]);
ylim([0.35,1]);
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);