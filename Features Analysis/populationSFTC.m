% function [Fit, Pop] = populationSFTC(Grat)

plotFlag = 1;

idx  = find( Grat.SFFitQuality > 50);

for n   = 1:length(idx)
    Stim = [];
    foo = Grat.SpkResponse{idx(n)};
    for ori = 1:3
        Stim = [];
        for sf = 1:9
            Stim  = [Stim; nanmean( foo{ori,sf}(41:120, :),2)];
        end;
         X{ori}(n,:) = Stim';
    end;
end;

for i = 1:3
    muStim  = nanmean(X{i},1);
    muStim  = reshape(muStim,80,9);
    TC(i,:) = mean(muStim,1);
end;

PopTC = mean(TC,1); err = std(TC,1);
S = linspace(-9,-2,200000) ;
[CoeffSet,R2] = fitSFTC(PopTC, min(PopTC));
Fit = DiffGaussians(CoeffSet,S);

Pop.PrefSF       = 2.^CoeffSet(4);
Pop.SFFitCoeffs  = CoeffSet;
Pop.SFFitQuality = R2; 

if plotFlag
    somColor = [190,30,45]./255;
    pvColor = [0, 0.45, 0.74];
    gray    = [0.3,0.3,0.3];


    figure(1); set(gcf,'color','w');
    SpatInc = [0, 0.002*2.^(0:9-2)];
    errorbar( log2(SpatInc), PopTC, err./sqrt(5),'o','color','k','linewidth',3,...
            'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
    plot( S, Fit,'color',somColor,'linewidth',3);

    set(gca,'xtick',SpatInc,'xticklabels',[]); xlim([-9,-1]);
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

    plot(S, Grat.Fit(1,:),'color',gray,'linewidth',3);
end;