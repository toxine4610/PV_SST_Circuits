addpath('../Build Data/');
addpath('../Reliabilty Analysis/');
%%
Filepath   = '../Data Repository/PV-ChR2/Mouse4/';
ExpDate    = '13-Jan-2015/';
ExpName    = 'Nat3/';
load( [Filepath ExpDate ExpName 'Mov.mat'] );

%% plot example raster
cmap = lines(5);
for n = 1:Mov.numCells
    
m = 4;
% figure(500); plot(Mov.dFF(n,:),'k'); hold on;
%            plot( 5*Mov.Spks(n,:),'g'); hold off;
% box off;set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

figure(n); set(gcf,'color','w');
subplot(2,5,1);
X = squeeze( Mov.MT_Nat{m}(:,:,n ));
imagesc( linspace(-4,4,160), 1:20, X);hold on;
colormap(b2r(0,2));
line( [0,0], [1,80],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy;; xlim([-4,4]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

figure(n);set(gcf,'color','w');
X = squeeze( Mov.MT_Nat{m}(:,:,n) );
subplot(2,5,6);
stdshadenew( linspace(-4,4,160), mean(X,1), std(X,[],1)./sqrt(20),1,'k'); hold on;
line( [0,0], [0,0.4],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy; xlim([-4,4]);ylim([0,5]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

% K05
figure(n);
subplot(2,5,2);
X = squeeze( Mov.MT_K05{m}(:,:,n) );
imagesc( linspace(-4,4,160), 1:20, X);hold on;
colormap(b2r(0,2));
line( [0,0], [1,80],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy; xlim([-4,4]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

figure(n);
X = squeeze( Mov.MT_K05{m}(:,:,n) );
subplot(2,5,7);
stdshadenew( linspace(-4,4,160), mean(X,1), std(X,[],1)./sqrt(20),1,cmap(1,:)); hold on;
line( [0,0], [0,0.4],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy; xlim([-4,4]);ylim([0,5]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

% K1
figure(n);
subplot(2,5,3);
X = squeeze( Mov.MT_K1{m}(:,:,n) );
imagesc( linspace(-4,4,160), 1:20, X);hold on;
colormap(b2r(0,2));
line( [0,0], [1,80],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy;; xlim([-4,4]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

figure(n);
X = squeeze( Mov.MT_K1{m}(:,:,n) );
subplot(2,5,8);
stdshadenew( linspace(-4,4,160), mean(X,1), std(X,[],1)./sqrt(20),1,cmap(2,:)); hold on;
line( [0,0], [0,0.4],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy;; xlim([-4,4]); ylim([0,5]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

% K2
figure(n)
subplot(2,5,4);
X = squeeze( Mov.MT_K2{m}(:,:,n) );
imagesc( linspace(-4,4,160), 1:20, X);hold on;
colormap(b2r(0,2));
line( [0,0], [1,80],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy; xlim([-4,4]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

figure(n)
X = squeeze( Mov.MT_K2{m}(:,:,n) );
subplot(2,5,9);
stdshadenew( linspace(-4,4,160), mean(X,1), std(X,[],1)./sqrt(20),1,cmap(3,:)); hold on;
line( [0,0], [0,0.4],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy; xlim([-4,4]);ylim([0,5]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

% Phase
figure(n);
subplot(2,5,5);
X = squeeze( Mov.MT_Ph{m}(:,:,n) );
imagesc( linspace(-4,4,160), 1:20, X);hold on;
colormap(b2r(0,2));
line( [0,0], [1,80],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy; xlim([-4,4]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

figure(n)
X = squeeze( Mov.MT_Ph{m}(:,:,n) );
subplot(2,5,10);
stdshadenew( linspace(-4,4,160), mean(X,1), std(X,[],1)./sqrt(20),1,cmap(4,:)); hold on;
line( [0,0], [0,0.4],'linestyle','--','color','k','linewidth',3);
axis square; box off; axis xy; xlim([-4,4]);ylim([0,5]);
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
drawnow;
end;
for m = 1:5
    R(1,m) = max(Mov.MTA_Nat{m}(n, 81:160));
    R(2,m) = max(Mov.MTA_K05{m}(n, 81:160));
    R(n,3,m) = max(Mov.MTA_K1{m}(n, 81:160));
    R(n,4,m) = max(Mov.MTA_K2{m}(n, 81:160));
    R(n,5,m) = max(Mov.MTA_Ph{m}(n, 81:160));
end;

%%
cmap = hsv(5);
for m = 1:5
    figure(m); set(gcf,'color','w')
%     subplot(1,4,1);
    stdshadenew(linspace(-4,4,160), mean(Mov.MTA_Nat{m},1), std(Mov.MTA_Nat{m},[],1)./sqrt(Mov.numCells),0.5,'k');
    axis square; box off; axis xy; xlim([-4,4]);
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
    
%     subplot(1,4,2);
    stdshadenew(linspace(-4,4,160), mean(Mov.MTA_K05{m},1), std(Mov.MTA_K05{m},[],1)./sqrt(Mov.numCells),0.5,cmap(1,:));
    axis square; box off; axis xy; xlim([-4,4]);
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

    stdshadenew(linspace(-4,4,160), mean(Mov.MTA_K1{m},1), std(Mov.MTA_K1{m},[],1)./sqrt(Mov.numCells),0.5,cmap(2,:));
    axis square; box off; axis xy; xlim([-4,4]);
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
    

%     subplot(1,4,3);
    stdshadenew(linspace(-4,4,160), mean(Mov.MTA_K2{m},1), std(Mov.MTA_K2{m},[],1)./sqrt(Mov.numCells),0.5,cmap(4,:));
    axis square; box off; axis xy; xlim([-4,4]);
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

%     subplot(1,4,4);
    stdshadenew(linspace(-4,4,160), mean(Mov.MTA_Ph{m},1), std(Mov.MTA_Ph{m},[],1)./sqrt(Mov.numCells),0.5,cmap(5,:));
    axis square; box off; axis xy; xlim([-4,4]);
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
end;