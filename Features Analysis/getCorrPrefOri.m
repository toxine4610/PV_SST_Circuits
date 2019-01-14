P = nchoosek(1:Ori.numCells, 2);
x = linspace(0,2,40);
xx = linspace(0,2,400);
for i = 1:size(P,1);
    p1 = P(i,1); p2 = P(i,2);
    Stim1 = []; Stim2 = [];
    Var1 = []; Var2 = [];
    for ori = 1:16
        Stim1  = [Stim1; nanmean( Ori.SpkResponse{p1}{ori}(81:120, :),2)];
        Stim2  = [Stim2; nanmean( Ori.SpkResponse{p2}{ori}(81:120, :),2)];
        
        mu1 = nanmean( Ori.SpkResponse{p1}{ori}(81:120, :),2);
        s1  = nanstd( Ori.SpkResponse{p1}{ori}(81:120, :),[],2);
        foo1 = (Ori.SpkResponse{p1}{ori}(81:120, :)-repmat(mu1,1,10))./repmat(s1,1,10);
        foo1 = reshape(foo1,1,400);
        
        mu2 = nanmean( Ori.SpkResponse{p2}{ori}(81:120, :),2);
        s2  = nanstd( Ori.SpkResponse{p2}{ori}(81:120, :),[],2);
        foo2 = (Ori.SpkResponse{p2}{ori}(81:120, :)-repmat(mu2,1,10))./repmat(s2,1,10);
        foo2 = reshape(foo2,1,400);

        Var1  = [Var1, foo1];
        Var2  = [Var2, foo2];
    end;
    SC(i) = corr(Stim1, Stim2);
    NC(i) = corr(Var1', Var2');
    delPO(i) = abs(Ori.PrefOri(p1) - Ori.PrefOri(p2) );
    
    OS1 = max(Ori.OSI(p1), Ori.OI(p1));
    OS2 = max(Ori.OSI(p2), Ori.OI(p2));
    delOSI(i) = abs(OS1-OS2);
    
end;

%%
[a,b] = histc( delPO, linspace(0,180,10) );
for i = 1:9
    SC_PO_mu(i) = mean( SC( b == i) );
    SC_PO_err(i) = std( SC( b == i) )./sqrt(a(i));
    
    NC_PO_mu(i) = mean( NC( b == i) );
    NC_PO_err(i) = std( NC( b == i) )./sqrt(a(i));
end;

figure(1); set(gcf,'color','w');
errorbar( linspace(0,180,9), SC_PO_mu, SC_PO_err,'-o','linewidth',3,'markerfacecolor','k',...
          'markeredgecolor','k','color','k','markersize',12);
hold on;
errorbar( linspace(0,180,9), NC_PO_mu, NC_PO_err,'-o','linewidth',3,'markerfacecolor','r',...
          'markeredgecolor','r','color','r','markersize',12);
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
xlim([0,180]); set(gca,'xtick',0:45:180);
xlim([-10,200]);

%%
[a,b] = histc( delOSI, linspace(0,.9,10) );
for i = 1:9
    SC_OS_mu(i) = mean( SC( b == i) );
    SC_OS_err(i) = std( SC( b == i) )./sqrt(a(i));
    
    NC_OS_mu(i) = mean( NC( b == i) );
    NC_OS_err(i) = std( NC( b == i) )./sqrt(a(i));
end;

figure(2); set(gcf,'color','w');
errorbar( linspace(0,0.8,9), smooth(SC_OS_mu), SC_OS_err,'-o','linewidth',3,'markerfacecolor','k',...
          'markeredgecolor','k','color','k','markersize',12);
hold on;
errorbar( linspace(0,0.8,9), NC_OS_mu, NC_OS_err,'-o','linewidth',3,'markerfacecolor','r',...
          'markeredgecolor','r','color','r','markersize',12);
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
xlim([0,0.9]); set(gca,'xtick',0:.2:0.8);
xlim([-0.1,1]);