x = linspace(0,1, 20000);

f = @(x,a,b) 1./( 1+exp( -(x-a)./b) );

figure(1); 
plot( x, f(x,0.5,0.1),'color','k' ); 
hold on;
plot( x, f(x,0.3,0.1),'color','r' );
plot( x, f(x,0.7,0.1) ,'color','b');
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);

figure(2); 
plot( x, f(x,0.5,0.1),'color','k' ); 
hold on;
plot( x, f(x,0.3,1),'color','r' );
plot( x, f(x,0.3,0.05) ,'color','b');
axis square; box off;
set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);