
function [HR_on, HR_off, FAR_on,FAR_off, d_prime_on, d_prime_off] = getVariables(MoviesToSearch,AllLaser,FreMovIndx,FreMovBehav)

Hit_off= [];
FA_off = [];
Miss_off = [];
CR_off  = [];

Hit_on= [];
FA_on = [];
Miss_on = [];
CR_on  = [];

for m = 1:length(MoviesToSearch)
    
    foo  = cell2mat(FreMovIndx{m});
    Laze = AllLaser(foo);
    
    indxOn = find(Laze == 1);
    indxOff = find(Laze == 0);
    X = cell2mat(FreMovBehav{m});
    
    Xon = X(indxOn);
    Xoff = X(indxOff);
    
    X_0_on = length(find(Xon == 0));
    X_1_on = length(find(Xon == 1));
    
    X_0_off = length(find(Xoff == 0));
    X_1_off = length(find(Xoff == 1));
    
    if ismember(m,[1,2])
        FA_on = [FA_on,X_1_on];
        CR_on = [CR_on,X_0_on];
    elseif ismember(m,[3,4,5])
        Hit_on = [Hit_on, X_1_on];
        Miss_on = [Miss_on, X_0_on];
    end;
    
    if ismember(m,[1,2])
        FA_off = [FA_off,X_1_off];
        CR_off = [CR_off,X_0_off];
    elseif ismember(m,[3,4,5])
        Hit_off = [Hit_off, X_1_off];
        Miss_off = [Miss_off, X_0_off];
    end;
    
end;

FAR_off = sum(FA_off )./( sum(FA_off ) + sum(CR_off ) );
HR_off = sum(Hit_off )./( sum(Hit_off ) + sum(Miss_off ) );
d_prime_off = norminv(HR_off ,0,1) - norminv(FAR_off,0,1 );

FAR_on = sum(FA_on )./( sum(FA_on ) + sum(CR_on ) );
HR_on = sum(Hit_on )./( sum(Hit_on ) + sum(Miss_on ) );
d_prime_on = norminv(HR_on ,0,1) - norminv(FAR_on,0,1 );

