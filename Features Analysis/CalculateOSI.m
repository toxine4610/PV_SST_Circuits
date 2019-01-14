function [OSI,PO,DSI] = CalculateOSI(X)

% This function calculates the OSI, Preferred Orientaion and Preferred
% Direction and Circular Mean of the data. It also returns the data
% arranged from 0 -> 337.5 degs.

if max(size(X))==5
    Angles   =  0:45:180;
    AngRad   = (Angles.*pi)./180;
elseif max(size(X))==16
    Angles   =  0:22.5:337.5;
    AngRad   = (Angles.*pi)./180;
end;
    

% OSI, DSI and Pref Ori....................................................
 OSI      =  abs(  sum(X.*exp(2.*1i.*AngRad))./sum(X) );
 DSI      =  abs(  sum(X.*exp(1.*1i.*AngRad))./sum(X) );
 PrefOri  =  0.5.*( angle(  sum(X.*exp(2.*1i.*AngRad))./sum(X) ) );
 PrefOri  = PrefOri.*(180/pi);
 if PrefOri < 0
     PO = (PrefOri+360);
 else
     PO = (PrefOri);
 end;
