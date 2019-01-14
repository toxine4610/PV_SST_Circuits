function F = PscyhFunction(Coeff,xdata)

F = 1./( 1 + exp( -(xdata-Coeff(1))./Coeff(2) ) );


% F = 1./( 1 + 10^( -Coeff(1).*(xdata-Coeff(2)) ) );