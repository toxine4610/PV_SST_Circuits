function [CoeffSet, resnorm] = fitPscyh(On)


%%
options    = optimset( 'Algorithm', 'trust-region-reflective', ...
                'Display','off','TolX',10^-10,'TolFun',10^-10,...
                    'MaxIter',5000);
                
 xax = [0,0.25,0.5,0.75,1];
 
 Coeff_init(1) = 0.5;
 Coeff_init(2) = 0.5 ;
 
 [CoeffSet,resnorm] = lsqcurvefit(@PscyhFunction,Coeff_init,xax, On ,[],[],options);
 
 
