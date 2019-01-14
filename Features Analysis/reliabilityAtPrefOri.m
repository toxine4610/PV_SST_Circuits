function [BestReliab, BestOSI, BestRel] = reliabilityAtPrefOri(Ori)

displayFlag = 1;
warning('off')
addpath('../Build Data/');
addpath('../Reliabilty Analysis/');
close all;

P = nchoosek(1:10,2);

for n = 1:Ori.numCells
    X = Ori.SpkResponse{n};
    for ori = 1:16
        foo = X{ori}(81:120,:);
        for j = 1:size(P,1)
            t1 = P(j,1); t2 = P(j,2);
            CC(j) = distcorr( foo(:,t1), foo(:,t2) )-0.3;
        end;
        Rel{n}(ori) = mean(CC);
    end;
    BestRel(n) = max(Rel{n});
end;

bestCells  = intersect( find(Ori.OrFitQuality>60), Ori.cell2keep);
BestReliab = BestRel(bestCells);
BestOSI    = Ori.OSI(bestCells);

if displayFlag == 1
    figure(1); set(gcf,'color','w');
    plot( BestOSI, BestReliab,'o','markersize',12,'markerfacecolor','k','markeredgecolor','k');
    hold on;
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
end;