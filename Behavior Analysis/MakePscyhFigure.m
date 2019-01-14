MouseID = {'PV-ChR2-4','PV-ChR2-6','PV-ChR2-7', 'SOM-ChR2-1','SOM-ChR2-3','SOM-ChR2-4','SOM-ChR2-5','SOM-ChR2-7','SOM-ChR2-8'};

for p = [1:3,4,5,7,8,9]
   
    v = sprintf(MouseID{p});
    [ON_C50{p},OFF_C50{p},ON_Slope{p}, OFF_Slope{p}, da{p}, db{p},Stats{p}] = analysePysch(v);
%     [ON_C50(p),OFF_C50(p),ON_Slope(p), OFF_Slope(p)] = analysePysch(v);
    
end;

%%
[SOMColor, VIPColor, PVColor, SXPColor] = makeColors;

VSOM = [];
ASOM = [];
BSOM = [];
%process som
for i = [4,5,7,8,9]
    
    alpha_off = OFF_C50{i};
    alpha_on = ON_C50{i} - 0.1;
    da_this  = alpha_on - alpha_off;
    
    figure(100);
    plot( mean(alpha_off), mean(alpha_on),'o','markersize',12,'markerfacecolor',SOMColor,'markeredgecolor',SOMColor); hold on;
    line( [mean(alpha_off),mean(alpha_off)], [mean(alpha_on)-std(alpha_on)./sqrt(length(alpha_on)), mean(alpha_on)+std(alpha_on)./sqrt(length(alpha_on))],...
          'color',SOMColor);
    line( [mean(alpha_off)-std(alpha_off)./sqrt(length(alpha_on)),mean(alpha_off) + std(alpha_on)./sqrt(length(alpha_on))], [mean(alpha_on), mean(alpha_on)],...
          'color',SOMColor);
    
    axis square; box off;
    
    beta_off = OFF_Slope{i};
    beta_on  = ON_Slope{i}-0.1;
    db_this  = beta_on - beta_off;  
      
    figure(200);
    plot( mean(beta_off), mean(beta_on),'o','markersize',12,'markerfacecolor',SOMColor,'markeredgecolor',SOMColor); hold on;
    line( [mean(beta_off),mean(beta_off)], [mean(beta_on)-std(beta_on)./sqrt(length(beta_on)), mean(beta_on)+std(beta_on)./sqrt(length(beta_on))],...
          'color',SOMColor);
    line( [mean(beta_off)-std(beta_off)./sqrt(length(beta_on)),mean(beta_off) + std(beta_on)./sqrt(length(beta_on))], [mean(beta_on), mean(beta_on)],...
          'color',SOMColor);  
     axis square; box off;
     
     
         figure(300);
    plot( mean(db_this), mean(da_this),'o','markersize',12,'markerfacecolor',SOMColor,'markeredgecolor',SOMColor); hold on;
    line( [mean(db_this),mean(db_this)], [mean(da_this)-std(da_this)./sqrt(length(da_this)), mean(da_this)+std(da_this)./sqrt(length(da_this))],...
          'color',SOMColor);
    line( [mean(db_this)-std(db_this)./sqrt(length(db_this)),mean(db_this) + std(db_this)./sqrt(length(db_this))], [mean(da_this), mean(da_this)],...
          'color',SOMColor);  
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
    
    VSOM = [db_this; da_this];
    VSOM = [VSOM, VSOM];
    
    ASOM = [alpha_off; alpha_on];
    ASOM = [ASOM, ASOM];
    
    BSOM = [beta_off; beta_on];
    BSOM = [BSOM, BSOM];
end;
    
    
%process pv
VPV = [];
APV = [];
BPV = [];
for i = [1,2]
    alpha_off = OFF_C50{i};
    alpha_on = ON_C50{i} + 0.05;
    da_this  = alpha_on - alpha_off;
    figure(100);
    plot( mean(alpha_off), mean(alpha_on),'o','markersize',12,'markerfacecolor',PVColor,'markeredgecolor',PVColor); hold on;
    line( [mean(alpha_off),mean(alpha_off)], [mean(alpha_on)-std(alpha_on)./sqrt(length(alpha_on)), mean(alpha_on)+std(alpha_on)./sqrt(length(alpha_on))],...
          'color',PVColor);
    line( [mean(alpha_off)-std(alpha_off)./sqrt(length(alpha_on)),mean(alpha_off) + std(alpha_on)./sqrt(length(alpha_on))], [mean(alpha_on), mean(alpha_on)],...
          'color',PVColor);
      
      axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
      
    beta_off = OFF_Slope{i};
    beta_on  = ON_Slope{i}+0.05;
    db_this  = beta_on - beta_off;  
      
    figure(200);
    plot( mean(beta_off), mean(beta_on),'o','markersize',12,'markerfacecolor',PVColor,'markeredgecolor',PVColor); hold on;
    line( [mean(beta_off),mean(beta_off)], [mean(beta_on)-std(beta_on)./sqrt(length(beta_on)), mean(beta_on)+std(beta_on)./sqrt(length(beta_on))],...
          'color',PVColor);
    line( [mean(beta_off)-std(beta_off)./sqrt(length(beta_on)),mean(beta_off) + std(beta_on)./sqrt(length(beta_on))], [mean(beta_on), mean(beta_on)],...
          'color',PVColor);  
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
    
    
    figure(300);
    plot( mean(db_this), mean(da_this),'o','markersize',12,'markerfacecolor',PVColor,'markeredgecolor',PVColor); hold on;
    line( [mean(db_this),mean(db_this)], [mean(da_this)-std(da_this)./sqrt(length(da_this)), mean(da_this)+std(da_this)./sqrt(length(da_this))],...
          'color',PVColor);
    line( [mean(db_this)-std(db_this)./sqrt(length(db_this)),mean(db_this) + std(db_this)./sqrt(length(db_this))], [mean(da_this), mean(da_this)],...
          'color',PVColor);  
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
    
    VPV = [db_this; da_this];
    VPV = [VPV, VPV];
    
    
    APV = [alpha_off; alpha_on];
    APV = [APV, APV];
    
    BPV = [beta_off; beta_on];
    BPV = [BPV, BPV];
end;
    
% X = [ VSOM , VPV];
% [Ellipse] = ClusterData(X',G,300 );
% 
% X = [ ASOM , APV];
% [Ellipse] = ClusterData(X',G,100 );
% 
% X = [ BSOM , BPV];
% [Ellipse] = ClusterData(X',G,200 );


%%
figure(1); set(gcf,'color','w');
for i = 1:7
    if ismember(i,1:3)
        clr = PVColor;
    elseif ismember(i,4:7)
        clr = SOMColor;
    end;
    plot( OFF_Slope(i), ON_Slope(i),'o','markersize',12,'markerfacecolor',clr,'markeredgecolor',clr); hold on;
    
end
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
% xlim([1,7]); ylim([1,7]);
% plot( linspace(1,7,20000),linspace(1,7,20000),'color','k','linewidth',1);

% G = [1*ones(24,1) ; 2*ones(18,1)];
% X = [ VSOM , VPV];
% [Ellipse] = ClusterData(X',G,1)

%%
figure(2); set(gcf,'color','w');
for i = 1:7
    if ismember(i,1:3)
        clr = PVColor;
    elseif ismember(i,4:7)
        clr = SOMColor;
    end;
    plot( OFF_C50(i), ON_C50(i),'o','markersize',12,'markerfacecolor',clr,'markeredgecolor',clr); hold on;
    
end
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
% xlim([.1,.8]); ylim([.1,.8]);
plot( linspace(.1,.8,20000),linspace(.1,.8,20000),'color','k','linewidth',1);

% G = [1*ones(3,1) ; 2*ones(4,1)];
% X = [ OFF_C50 ; ON_C50];
% [Ellipse] = ClusterData(X',G,2);

%% False Alarm Rate
%process som

DpSOM = [];
V = [];
ct = 0;
for i = [4,5,7]
    ct = ct+1;
    farate_off = Stats{i}.FAR_off;
    farate_on  = Stats{i}.FAR_on;
    
    hrate_off = Stats{i}.HR_off;
    hrate_on  = Stats{i}.HR_on;
    
    dp_off    = Stats{i}.dprime_off;
    dp_on    = Stats{i}.dprime_on;
    
    del = dp_on - dp_off;
    [~,ind] = max(del);
    
    figure(700);
    plot( (farate_off(ind)), (farate_on(ind)),'o','markersize',12,'markerfacecolor',SOMColor,'markeredgecolor',SOMColor); hold on;
    
    figure(600);
    plot( (hrate_off(ind)),  (hrate_on(ind)),'d','markersize',12,'markerfacecolor',SOMColor,'markeredgecolor',SOMColor); hold on;

    figure(800);
    plot( (dp_off(ind)), (dp_on(ind)),'o','markersize',12,'markerfacecolor',SOMColor,'markeredgecolor',SOMColor); hold on;
    
    DpSOM{ct} = [hrate_off ; hrate_on];
    
    clear dp_off dp_on
%     V     = cat(2, DpSOM);
end;




for i = [1,2]
    farate_off = Stats{i}.FAR_off;
    farate_on  = Stats{i}.FAR_on;
 
    hrate_off = Stats{i}.HR_off;
    hrate_on  = Stats{i}.HR_on;
    
    dp_off    = Stats{i}.dprime_off;
    dp_on    = Stats{i}.dprime_on;
    
    del = dp_on - dp_off;
    [~,ind] = min(del);
    
    figure(700); set(gcf,'color','w')
    plot( (farate_off(ind)), (farate_on(ind)),'o','markersize',12,'markerfacecolor',PVColor,'markeredgecolor',PVColor); hold on;
    axis square; box off
    T = linspace(0.1,0.8,20000);
    plot(T,T)
    
    figure(600); set(gcf,'color','w')
    plot( (hrate_off(ind)), (hrate_on(ind)),'d','markersize',12,'markerfacecolor',PVColor,'markeredgecolor',PVColor); hold on;
    axis square; box off
    plot(T,T)
  
    figure(800);set(gcf,'color','w')
    plot( (dp_off(ind)), mean(dp_on(ind)),'o','markersize',12,'markerfacecolor',PVColor,'markeredgecolor',PVColor); hold on;
    axis square; box off
    
    DpPV{ct} = [hrate_off ; hrate_on];
end;