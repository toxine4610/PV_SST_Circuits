function [ON_C50, ON_Slope,OFF_C50, OFF_Slope,da,db,Stats] = analyzePscyhv2(Names)

%%
warning off;
addpath('../Build Data/');
addpath('../Features Analysis/');
addpath('../Reliability Analysis/');
[SOMColor, VIPColor, PVColor, SXPColor] = makeColors;

path = ['../Behavior Repository/Pyschometric/'];
MouseID = [Names '/'];

A = dir( [path MouseID] );
for i = 3:max(size(A))
    Folders{i-2} = A(i).name;
end;

if strcmpi(MouseID,'SOM-ChR2-1/')
    indx = [4,5,8:17];
     indx = setdiff( indx, [12,14,15]);
    clr = SOMColor;
    corrflag = 0;
elseif strcmpi(MouseID,'SOM-ChR2-3/')
    indx = [4,5,8:17];
    indx = setdiff( indx, [4,9,12,14]);
    clr = SOMColor;
    corrflag = 0;
elseif strcmpi(MouseID,'SOM-ChR2-4/')
    indx = setdiff( [1:14], [2,3,4,7,9]);
    clr = SOMColor;
    corrflag = 1;
elseif strcmpi(MouseID,'SOM-ChR2-5/')
    indx = [1:14];
    indx = setdiff( indx, [8,13])
    clr = SOMColor;
    corrflag = 0;
    
elseif strcmpi(MouseID,'SOM-ChR2-7/')
    indx = [1:12];
    clr = SOMColor;
    corrflag = 0;

elseif strcmpi(MouseID,'SOM-ChR2-8/')
    indx = [1:12];
    clr = SOMColor;
    corrflag = 0;
    
elseif strcmpi(MouseID,'PV-ChR2-4/')
    %    indx = [4,5,8:17];
    indx = 1:17;
    indx = setdiff( indx, [11,12,13,16,17]);
    clr = PVColor;
    corrflag = 0;
elseif strcmpi(MouseID,'PV-ChR2-6/')
    %     indx = 1:17;
    indx = [4,5,8:17];
     indx = setdiff( indx, [9]);
    clr = PVColor;
    corrflag = 0;
elseif strcmpi(MouseID,'PV-ChR2-7/')
    indx = setdiff( 2:14,3 );
    clr = PVColor;
     corrflag = 1;
elseif strcmpi(MouseID,'PV-ChR2-10/')
    indx = 1:12;
    clr = PVColor;
     corrflag = 0;
     
end;

%%
ct = 0;

xax = [0,0.25,0.5,0.75,1];
x_vector =min(xax):(max(xax)-min(xax))/100:max(xax);

for i = indx
    ct = ct+1;
    A = load([path MouseID Folders{i} '/Data.mat'])
    
    PS = getPsychometric(A.data, 1, corrflag);
    
    
    On(ct,:) = PS.PerCorrectON;
    Off(ct,:) = PS.PerCorrectOFF;
    
    Stats.FAR_on(ct) = PS.FAR_on;
    Stats.FAR_off(ct) = PS.FAR_off;
    
    Stats.HR_on(ct) = PS.HR_on;
    Stats.HR_off(ct) = PS.HR_off;
    
    Stats.dprime_on(ct) = PS.d_prime_on;
    Stats.dprime_off(ct) = PS.d_prime_off;
    
    [Coeffset, resnorm] = fitPscyh(On(ct,:));
    alphaON(ct) = Coeffset(1);
    betaON(ct)  = Coeffset(2);
    GOFON(ct)   = 1 - resnorm / norm(On(ct,:)-mean(On(ct,:)))^2;
    
    
        ONFIT = PscyhFunction(Coeffset, x_vector);
        plot( x_vector, ONFIT);
    
    
    [Coeffset, resnorm] = fitPscyh(Off(ct,:));
    alphaOFF(ct) = Coeffset(1);
    betaOFF(ct)  = Coeffset(2);
    GOFOFF(ct)   = 1 - resnorm / norm(Off(ct,:)-mean(Off(ct,:)))^2;
      
    OFFFIT = PscyhFunction(Coeffset, x_vector);
     plot( x_vector, OFFFIT);
    
end;


keep = intersect( find(GOFOFF > 0.7), find(GOFON > 0.7 ));
%%
optoClr = [0,191,255]./255;
xax = [0,0.25,0.5,0.75,1];
figure(2); set(gcf,'color','w');
hold on;


x_vector =min(xax):(max(xax)-min(xax))/100:max(xax);

if length(keep) > 1
    [Coeffset, resnorm] = fitPscyh(mean(On(keep,:)));
    ON_C50    = alphaON(keep);
    ON_Slope  = betaON(keep);
    ONMdl     = PscyhFunction(Coeffset,x_vector);
    
    [Coeffset, resnorm] = fitPscyh(median(Off(keep,:)));
    OFF_C50   = alphaOFF(keep);
    OFF_Slope = betaOFF(keep);
    OFFMdl    = PscyhFunction(Coeffset,x_vector);
    
    
    errorbar( xax, mean(On,1), std(On,[],1)./sqrt(size(On,1)), 'o','markersize',12,'markerfacecolor',optoClr,'markeredgecolor',optoClr,'color',optoClr);
    errorbar( xax, mean(Off,1), std(Off,[],1)./sqrt(size(Off,1)), 'o','markersize',12,'markerfacecolor','k','markeredgecolor','k','color','k');
    plot( x_vector, ONMdl, 'color', optoClr, 'linewidth',3);
    plot( x_vector, OFFMdl, 'color', 'k', 'linewidth',3);
    
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    set(gca,'xtick',xax);
    xlim([-0.1,1.1]);
    
    
    figure(4); set(gcf,'color','w');
    subplot(1,2,1);
    plot( mean(alphaOFF(keep)), mean(alphaON(keep)),'o','markersize',12,'markerfacecolor',clr,'markeredgecolor', clr); hold on;
    line( [mean(alphaOFF(keep)), mean(alphaOFF(keep))], [ mean(alphaON(keep))-(std(alphaON(keep)))./sqrt(length(keep)),  mean(alphaON(keep))+(std(alphaON(keep)))./sqrt(length(keep))], 'color',clr);
    line( [mean(alphaOFF(keep))-(std(alphaOFF(keep)))./sqrt(length(keep)), mean(alphaOFF(keep))+(std(alphaOFF(keep)))./sqrt(length(keep))], [ mean(alphaON(keep)),  mean(alphaON(keep))], 'color',clr);

    plot( linspace(0,0.4, 10000), linspace(0,0.4,10000),'color','k');
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    
    
    subplot(1,2,2);
    plot( mean(betaOFF(keep)), mean(betaON(keep)),'o','markersize',12,'markerfacecolor',clr,'markeredgecolor', clr); hold on;
    line( [mean(betaOFF(keep)), mean(betaOFF(keep))], [ mean(betaON(keep))-std(betaON(keep))./sqrt(length(keep)),  mean(betaON(keep))+std(betaON(keep))./sqrt(length(keep))], 'color',clr);
    line( [mean(betaOFF(keep))-std(betaOFF(keep))./sqrt(length(keep)), mean(betaOFF(keep))+std(betaOFF(keep))./sqrt(length(keep))], [ mean(betaON(keep)),  mean(betaON(keep))], 'color',clr);
    plot( linspace(0,0.4, 10000), linspace(0,0.4,10000),'color','k');

    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    
    da = alphaON(keep) - alphaOFF(keep);
    db = betaON(keep) - betaOFF(keep);
    
    figure(5); set(gcf,'color','w');
    plot(db, da,'o','markersize',12,'markerfacecolor',clr,'markeredgecolor',clr);
    hold on;
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    plot( mean(db), mean(da), '+', 'markersize',28,'markerfacecolor',clr,'markeredgecolor',clr,'linewidth',3);
    
    
elseif length(keep) == 1
    [Coeffset, resnorm] = fitPscyh((On(keep,:)));
    ON_C50  = Coeffset(1);
    ON_Slope  = Coeffset(2);
    ONMdl = PscyhFunction(Coeffset,x_vector);
    
    [Coeffset, resnorm] = fitPscyh((Off(keep,:)));
    OFF_C50 = Coeffset(1);
    OFF_Slope = Coeffset(2);
    OFFMdl = PscyhFunction(Coeffset,x_vector);
    
    errorbar( xax, mean(On,1), std(On,[],1)./sqrt(size(On,1)), 'o','markersize',12,'markerfacecolor',optoClr,'markeredgecolor',optoClr,'color',optoClr);
    errorbar( xax, mean(Off,1), std(Off,[],1)./sqrt(size(Off,1)), 'o','markersize',12,'markerfacecolor','k','markeredgecolor','k','color','k');
    plot( x_vector, ONMdl, 'color', optoClr, 'linewidth',3);
    plot( x_vector, OFFMdl, 'color', 'k', 'linewidth',3);
    
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    set(gca,'xtick',xax);
    xlim([-0.1,1.1]);
    
    
    figure(3); set(gcf,'color','w');
    subplot(1,2,1);
    b = bar(1, OFF_C50); hold on;
    set(b(1),'facecolor','k');
    b = bar(2, ON_C50);
    set(b(1),'facecolor',optoClr);
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    
    subplot(1,2,2);
    b = bar(1, OFF_Slope); hold on;
    set(b(1),'facecolor','k');
    b = bar(2, ON_Slope);
    set(b(1),'facecolor',optoClr);
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    
    
    figure(4); set(gcf,'color','w');
    subplot(1,2,1);
    plot( OFF_C50, ON_C50,'o','markersize',12,'markerfacecolor',clr,'markeredgecolor', clr); hold on;
%     plot( linspace(0,0.4, 10000), linspace(0,0.4,10000),'color','k');
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    
    
    subplot(1,2,2);
    plot( OFF_Slope, ON_Slope,'o','markersize',12,'markerfacecolor',clr,'markeredgecolor', clr); hold on;
%     plot( linspace(1,5, 10000), linspace(1,5,10000),'color','k');
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
    
    
    
elseif length(keep) == 0
    OFF_C50 = NaN;
    OFF_Slope = NaN;
    
    ON_C50 = NaN;
    ON_Slope = NaN;
end;

