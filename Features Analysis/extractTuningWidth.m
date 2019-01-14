function Width = extractTuningWidth(Coeff)

s = Coeff(4);
if s > -0.5*log(0.5) 
   w = acos( (s - log(2))/s );
   Width = w*180/pi;
else
   Width = NaN;
end;