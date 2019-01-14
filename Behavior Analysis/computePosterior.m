
function prob = computePosterior(pTarget, pNonTarget, numTargets, numNonTargets, numHits, numFA)

pToss = 0.5;

Num = pTarget*( nchoosek(numTargets, numHits) * (pToss^(numTargets)) );

Den = ( pTarget*( nchoosek(numTargets, numHits) * (pToss^(numTargets)) ) ) + ( pNonTarget*( nchoosek(numNonTargets, numFA) * (pToss^(numNonTargets)) ) );

prob  = Num/Den;