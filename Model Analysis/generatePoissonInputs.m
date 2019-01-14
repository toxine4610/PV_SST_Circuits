function [Inh, Exc] = generatePoissonInputs(NExc, NInh,Number_Exc_Clusters,Number_Inh_Clusters,RateExc,RateInh,time, no_steps)

plotFlag = 0;
%% Exc Population
fprintf('Generating Exc. Inputs...');
Exc = [];
% RateExc = 0.1;
% Number_Exc_Clusters = 800; % <-- increasing this number will increase stochasticity

if Number_Exc_Clusters ~= NExc
    fprintf('Simulating with %d ensembles', Number_Exc_Clusters);
    NumberTrains  = NExc./Number_Exc_Clusters;
    
    for i = 1:Number_Exc_Clusters
        
        foo = poissrnd(RateExc,[1,no_steps]);
        foo(foo>1) = 1;
        foo_this_clust = repmat( foo, NumberTrains,1);
        
        Exc = cat(1, Exc, foo_this_clust );
    end;
    
    Exc = Exc( randperm(NExc), : );
    
elseif Number_Exc_Clusters == NExc
    fprintf('Simulating fully randomized network');
    Exc = poissrnd( 0.1, [NExc, no_steps] );
    Exc(Exc >= 1) = 1;
end;

if plotFlag
figure(2); set(gcf,'color','w');
subplot(1,3,1);
imagesc( time, 1:NExc, Exc ); colormap(1-gray);
box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
title('Exc. Inputs into model');
end;

fprintf('...Done\n');
%%
fprintf('Generating Inh. Inputs...');
Inh = [];
% RateInh = 0.2;
% Number_Inh_Clusters = 5; % <-- increasing this number will increase stochasticity

if Number_Inh_Clusters ~= NInh
    fprintf('Simulating with %d ensembles', Number_Inh_Clusters);
    NumberTrains  = NInh./Number_Inh_Clusters;
    
    for i = 1:Number_Inh_Clusters
        
        foo = poissrnd(0.1,[1,no_steps]);
        foo(foo>1) = 1;
        foo_this_clust = repmat( foo, NumberTrains,1);
        
        Inh = cat(1, Inh, foo_this_clust );
    end;
    
    Inh = Inh( randperm(NInh), : );
    
elseif Number_Inh_Clusters == NInh
    fprintf('Simulating fully randomized network');
    Inh = poissrnd( RateInh, [NInh, no_steps] );
    Inh(Inh >= 1) = 1;
end;

if plotFlag
figure(2); set(gcf,'color','w');
subplot(1,3,2);
imagesc( time, 1:NInh, Inh ); colormap(1-gray);
box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04],'yaxislocation','left')
title('Inh. Inputs into model');
end;

fprintf('...Done\n');

