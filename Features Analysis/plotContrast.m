function plotContrast
warning('off')
close all;
%%
Filepath   = '../Data Repository/PV-Animals/PV-K/';
ExpDate    = '4-Dec-2014/';
ExpName    = 'Nat1/';
load( [Filepath ExpDate ExpName 'Grat.mat'] );
%% make tuning curve.
plotFlag   = 1;
rasterFlag = 0;

cmap = (1-gray(5));

fprintf('Processing %d cells\n',Grat.numCells);
for n = 1:Grat.numCells
    
    indxON  = 81:120;
    indxOFF = 1:80;
    
    NumContrast = 5;
    NumOrient   = 9;
    Angles      = 0:22.5:180;
    SpatInc     = [0.1:0.2:0.9];
    
    Grat.Angles = Angles;
    Grat.SpatInc = SpatInc;
    
    ct = 0;
    for cont = 1:5
        for ori = 1:9
            ct = ct+1;
            foo = Grat.SpkResponse{n}{ori, cont};
            foo = foo';
            ON  = foo(:, indxON);
            OFF(ori,cont) = mean( mean(foo(:, indxOFF),1) );
            muONVec = mean(ON,1); % average over trials.
            %             if rasterFlag
            %                 figure(100+n); set(gcf,'color','w');
            %                 subplot(5, 9, ct);
            %                 stdshadenew( linspace(-2,4,120), mean(foo,1), std(foo,[],1)./sqrt(6),0.2,'k');
            %                 line([0,0],[0,4],'linestyle','--','color','r'); hold on;
            %                 axis square; box off; xlim([-2,4]); ylim([0,4]);
            %             end;
            muONVal(ori,cont) = mean(muONVec); % average over time;
            sONVec =  mean(ON,2); % average over trials.
            sdONVal(ori,cont) = std(sONVec);
        end;
    end;
    
    if plotFlag
        figure(n); set(gcf,'color','w');
        imagesc(SpatInc,Angles, muONVal./max(muONVal(:))); axis square; box off;
        set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        set(gca,'yticklabels',Angles);set(gca,'xticklabels',SpatInc);
        
        % tuning curve..........................................
        figure(n+100); set(gcf,'color','w');
        for c = 1:NumContrast
            errorbar( Angles, muONVal(:,c), sdONVal(:,c)./sqrt(6),'-o','color','k','linewidth',1,...
                'markersize',12,'markerfacecolor',cmap(c,:),'markeredgecolor','k');
            hold on;
            colormap(cmap); colorbar;
            axis square; box off;
            set(gca,'xtick',Angles,'xticklabels',[]); xlim([-10, 180]);
            set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
        end;
    end;
    drawnow
end;

%% save
save( [Filepath ExpDate ExpName 'Grat.mat'],'Grat' );