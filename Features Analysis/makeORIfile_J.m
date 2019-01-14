function Ori = makeORIfile_J( grating_resp_mat, num_cells )

Angles = linspace(0,340,18);

for n = 1:num_cells
    
    
    [CoeffSet,R2] = FitTCFull_J(grating_resp_mat(:,n)');
    
    Ors = linspace(0,340,200000);
    Ori.OrFit(n,:) = VonMisesFuntionNew(CoeffSet,Ors*(pi/180));
    
    Ori.OrFitCoeffs{n} = CoeffSet;
    Ori.OrFitQuality(n)= R2;
    Ori.Matrix{n}   = grating_resp_mat(:,n)';
    F0_mean = VonMisesFuntionNew(CoeffSet,Angles*(pi/180));
    [OSI, PrefOri] = CalculateOSI_J( F0_mean );
    %     OI = empiricalOI_J(F0_mean);
    %     Ori.OI(n)  = OI;
    Ori.OSI(n) = OSI;
    %     Ori.BestOSI(n) = max(OI,OSI);
    if PrefOri > 180
        Ori.PrefOri(n) = PrefOri - 180;
    else
        Ori.PrefOri(n) = PrefOri;
    end;
    
    figure(n); set(gcf,'color','w');
    plot( Angles, grating_resp_mat(:,n),'-o','color','k','linewidth',3,...
        'markersize',12,'markerfacecolor','k','markeredgecolor','k'); hold on;
    
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
    xlim([0, 360]); set(gca,'xtick',0:90:360); xlim([-20,360]);
    plot( Ors, Ori.OrFit(n,:),'color','r','linewidth',3);
    drawnow
    
    
    
end;