function tuningWidth = getTuningWidthNew(Ori)

Ors = linspace(0,337.5,200000);
xax  = linspace(0,180,200000/2);

for i = 1:Ori.numCells
    Fit = Ori.OrFit(i,:);
    
    FitN  = mean([ Fit(1:200000/2); Fit(200000/2 + 1: 200000)]);
    
    try
        [fitobject, gof]   = fit(xax',FitN','gauss2');
        
        if gof.rsquare > 0.7
            tuningWidth(i) = min(fitobject.c1, fitobject.c2);
        else
            tuningWidth(i) = NaN;
        end;
        clear fitobject
        
    catch err
        uningWidth(i) = NaN;
    end;
    
end;


