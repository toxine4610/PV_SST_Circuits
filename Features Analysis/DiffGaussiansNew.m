function F = DiffGaussiansNew(Coeff,sf)

F =  Coeff(1) + ...
     Coeff(2).*exp(-((sf-Coeff(4)).^2)./2*Coeff(5)) + ...
     Coeff(3).*exp(-((sf-Coeff(4)).^2)./2*Coeff(6));
 
 

