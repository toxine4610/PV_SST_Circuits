
function [Reliab, CaModel] = computeModelRel(Spike,time);

indx = find(~cellfun(@isempty,Spike));
ct = 0;
for t = 1:length(indx)
    trial = indx(t);
    ct = ct+1;
    foo = Spike{trial};    
    Spiketrain = zeros(1,length(time));
    for i = 1:length(foo)
        index = find( time == foo(i) );
        Spiketrain(index) = 1;
    end;
    CaModel(ct,:) = smoothts(Spiketrain, 'e', 20);
end;

P = nchoosek(1:ct,2);
for t = 1:size(P,1)
    t1 = P(t,1);
    t2 = P(t,2);
    Rel(t) = corr( CaModel(t1,1:4000)', CaModel(t2,1:4000)');
end;
Reliab = nanmean(Rel);