
function [Reliab_Inhib, Reliab_Exc] = computeInputRel(InhibInput, ExcInput);
P = nchoosek(1:size(InhibInput,2), 2);

for i = 1:size(P,1)
    p1 = P(i,1); p2 = P(i,2);
    RelI(i) = corr(InhibInput{p1}', InhibInput{p2}');
    RelE(i) = corr(ExcInput{p1}', ExcInput{p2}');
end;
Reliab_Inhib = nanmean(RelI);
Reliab_Exc   = nanmean(RelE);