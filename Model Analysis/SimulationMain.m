ct = 0;
n = [5,10,20,50,100,200];
for i = 1:length(n);

    ct = ct+1;
    [Reliab_Inhib{ct}, Reliab_Exc{ct}, Reliab_Output{ct}, Spike{ct}] = LIFReliabilitySimulation(400,n(i));
    
end;