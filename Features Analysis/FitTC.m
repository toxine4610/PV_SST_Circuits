function [CoeffSet,R2] = FitTC(TC)

theta = 0:45:180;
thetaRad = theta.*(pi./180);
[v,i] = max(TC);
PD = theta(i);

Coeff_init = zeros(1,5);
Coeff_init(1) = mean(TC);
Coeff_init(2) = max(TC);
Coeff_init(3) = max(TC);
Coeff_init(4) = pi*0.1250;
Coeff_init(5) = PD.*(pi/180);

options    = optimset( 'Algorithm', 'trust-region-reflective', ...
                       'Display','off','TolX',10^-8,'TolFun',10^-8,...
                       'MaxIter',1000);
                   
LowerBound = [-v,0,0,0.1250*pi,0];
UpperBound = [max(TC),3*max(TC),3*max(TC),8,2*pi];

[CoeffSet,resnorm] = lsqcurvefit(@VonMisesFuntionNew, Coeff_init, thetaRad, TC, LowerBound, UpperBound ,options);
R2 = 100.*(1 - resnorm / norm(TC-mean(TC))^2 );


