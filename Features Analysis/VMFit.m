function [CoeffSet] = VMFit(Observed)

theta = 0:45:180;
thetaRad = theta.*(pi./180);

Coeff_init = zeros(1,4);
Coeff_init(1) = mean(Observed);
Coeff_init(2) = max(Observed);
Coeff_init(3) = 1;
[v,i] = max(Observed);
PD = theta(i);
Coeff_init(4) = PD.*(pi/180);

options    = optimset( 'Algorithm', 'trust-region-reflective', ...
                       'Display','iter','TolX',10^-8,'TolFun',10^-8,...
                       'MaxIter',500);
                   
LowerBound = [0,0,1,0];
UpperBound = [max(Observed),max(Observed),8,2*pi];

% LowerBound = [0,0,0,3,0];
% UpperBound = [Coeff_init(2),Coeff_init(2),Coeff_init(2), inf, 360];

% CoeffSet = lsqnonlin(@findDiff, Coeff_init, LowerBound,UpperBound, options);

[CoeffSet] = lsqcurvefit(@VonMisesFuntion, Coeff_init, thetaRad, Observed, LowerBound, UpperBound ,options);


