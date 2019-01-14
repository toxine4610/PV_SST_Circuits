
function [XCut, CutPoint] = removeNonRespTrials(X);
ct = 0;

for i = 1 :2:length(X)-5
    ct= ct+1;
    f = find( X( i:i+4) == 0) ;
    lenzero(ct) = length(f);
end;

numberofmissedblocks = length( find(lenzero == 5) );
fracmissed           = numberofmissedblocks/ct;


v = 1:2:length(X)-5;

indx = (find(lenzero == 5));


if ~isempty(indx)
    d    = diff(indx);
    firststeady = find(d==1);
    if ~isempty(firststeady)
        firststeady = firststeady(1);

        XCut = X( 1:v(indx(firststeady)) );
        CutPoint = v(indx(firststeady));
    else
        XCut = X;
        CutPoint = length(X);
    end;
else
    XCut = X;
    CutPoint = length(X);
end;