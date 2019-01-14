function OI = empiricalOI(X)

Angles = 0:22.5:337.5;

[v,i]    =  max(X);

ThetaPref     =  Angles(i);
ThetaOrth_pos =  mod(ThetaPref+90, 180);
ThetaOrth_neg =  mod(ThetaPref-90, 180);
ThetaNull     =  ThetaPref+180;

if ThetaNull  > 180
    Resp_null = 0;
else
    Resp_null     = X( find(Angles == ThetaNull));
end;

Resp_pref     = v;
Resp_orthpos  = X( find(Angles == ThetaOrth_pos));
Resp_orthneg  = X( find(Angles == ThetaOrth_neg));


OI  =  (Resp_pref + Resp_null) - (Resp_orthpos + Resp_orthneg) ;
OI  = OI./(Resp_pref + Resp_null);

 