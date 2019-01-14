function F = VonMisesFuntion(Coeff,theta)

F =  Coeff(1) + ...
     Coeff(2).*exp( Coeff(3).*(cos(theta - Coeff(4))-1));