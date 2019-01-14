function BlockLicksData=TrialSegment(Bstr,Bend,PreCueT,licks,ai_fs,TrialSamples,Ntrial,stimT,Params)

BlockLicksData=zeros(1,TrialSamples*Ntrial);  %% container for lick data for this block; in samples.
PreCueSample=PreCueT*ai_fs;
stimT=stimT(1:Ntrial);

%%% Does lick time zeroed at trial onset??? yes. Because lick time is using
%%% the same timestamp
licks=floor(licks*ai_fs);  %% lick in samples. 

for i=1:Ntrial,
    
    TrialW=floor([stimT(i)-Params.durCueDelay-PreCueT stimT(i)+Params.TrialDur-Params.durCueDelay-PreCueT]*ai_fs);  %% absoulte sample index
    
    BlocklickIndex=find(licks(Bstr:Bend)>TrialW(1) & licks(Bstr:Bend) < TrialW(2));
    BlocklickIndex=BlocklickIndex+Bstr-1;
    licksSample=licks(BlocklickIndex)-TrialW(1); %% licks happen during this trial window. in samples, relative to the start of window
    
    LickData=zeros(1,TrialSamples); %% trial vector
    LickData(licksSample)=1;  %% fill in 1 when licks.

    TrialSampleW=(i-1)*TrialSamples+1:i*TrialSamples;
    BlockLicksData(TrialSampleW)=LickData;
    
end;