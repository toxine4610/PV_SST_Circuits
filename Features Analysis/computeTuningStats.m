function [OSI, PrefOri] = computeTuningStats(F0_mean)

Angles   =  0:45:180;
AngRad   = (Angles.*pi)./180;

% F0 component............................................................
a = sum( F0_mean.*cos(2.*AngRad) );
b = sum( F0_mean.*sin(2.*AngRad) );

if a > 0
   PrefOri = 0.5.*atan2(b,a);
elseif a < 0
   PrefOri = pi + 0.5.*atan2(b,a); 
end;

PrefOri = PrefOri.*(180/pi);

OSI = (sqrt(a.^2 + b.^2))./sum(F0_mean);
