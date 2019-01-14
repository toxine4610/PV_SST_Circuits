function [CoeffSet,R2] = fitSFTC(SFTC, BaseLine)

NumSpatFreq = 9;
SpatInc = [0, 0.0025, 0.005, 0.01, 0.02, 0.04, 0.08, 0.16, 0.32];
SpatInc = SpatInc(2:end);
SpatInc = log2(SpatInc);

SFTC = SFTC(2:end);

options    = optimset( 'Algorithm', 'trust-region-reflective', ...
    'Display','off','TolX',10^-10,'TolFun',10^-10,...
    'MaxIter',3000);

% initialize...............................................................

[v,i] = max(SFTC);

modelType = 'SingleGaussian';

switch modelType
    case 'DoubleGaussian'
        Coeff_init    = zeros(1,6);
        Coeff_init(1) = BaseLine;  % baseline
        Coeff_init(2) = v;          % peak e
        Coeff_init(3) = v;          % peak i
        Coeff_init(4) = SpatInc(i); % mu e
        Coeff_init(5) = .001;          % sig2 e
        Coeff_init(6) = .001;          % sig2 i
        
        LowerBound(1)   =  0;
        LowerBound(2:3) =  -v;
        
        UpperBound(1)    = BaseLine;
        UpperBound(2:3)  = v;
        UpperBound(4)    = 2;
        UpperBound(5)    = .5;
        UpperBound(6)    = .5;
        
        
        [CoeffSet,resnorm] = lsqcurvefit(@DiffGaussiansNew,Coeff_init,SpatInc,SFTC,[],[],options);
        
        if ~isempty(resnorm)
            R2 = 100.*(1 - resnorm / norm(SFTC-mean(SFTC))^2 );
        else
            R2 = 0;
        end;
        
    case 'SingleGaussian'
        Coeff_init    = zeros(1,4);
        Coeff_init(1) = BaseLine;  % baseline
        Coeff_init(2) = v;          % peak e
        Coeff_init(3) = .001;       % sig2 e
        Coeff_init(4) = SpatInc(i); % mu e
        
        LowerBound(1)   =  0;
        LowerBound(2)   =  -v;
        
        UpperBound(1)   = BaseLine;
        UpperBound(2)   = v;
        UpperBound(3)   = .5;
        UpperBound(4)   = 2;
        
        [CoeffSet,resnorm] = lsqcurvefit(@DiffGaussians,Coeff_init,SpatInc,SFTC,[],UpperBound,options);
        
        if ~isempty(resnorm)
            R2 = 100.*(1 - resnorm / norm(SFTC-mean(SFTC))^2 );
        else
            R2 = 0;
        end;
end;

