function PS = getPsychometric(data, lightused, corrflag)

saveFlag = 0;
PreCueT=0.5; %% time window before sound cue.
if isfield(data,'card')
    PreCueSamples=PreCueT*data.card.ai_fs;
else
    PreCueSamples=PreCueT*64;
end;
%% handle laser events
AllLaser  = zeros(600,1);

LaserEventsTar  = data.Params.LazeFlag;
LaserEventsTar  = LaserEventsTar(:);
LaserOnIndex    = find(LaserEventsTar==1);
AllLaser(LaserOnIndex) = 1;

LaserEventsNonTar = data.Params.LazeFlagFreq;
LaserEventsNonTar = LaserEventsNonTar(:);
LaserOnIndexNT    = find(LaserEventsNonTar==1);

AllLaserIndices   = union(LaserOnIndex, LaserOnIndexNT);
AllLaser(AllLaserIndices) = 1;

%%
FreMov = data.Params.NonPunishedMov;
OddMov = data.Params.PunishedMov;

MoviesToSearch = [data.Params.NonRewardedMovies, data.Params.RewardedMovies];

TrialSamples   = (data.Params.TrialDur+PreCueT)*data.card.ai_fs; %% # of samples per trial
RewardWVector  = zeros(1,TrialSamples);
StageSampleIdx = round([0,data.Params.durCueDelay,data.Params.durCueDelay+data.Params.durStim,data.Params.TrialDur-data.Params.durBlank]*data.card.ai_fs); %% sample index for onset of each stage

%%% RewardWIdx is the time window when mouse can get reward if it licks.
RewardWIdx = round(data.response.reward_window*data.card.ai_fs); %% reward Windows  in unit of sample index relative to onset of each stage
RewardWIdx = RewardWIdx+repmat(StageSampleIdx,2,1); %% reward window in unit of sample index relative to onset of trial

for idx = 2:2:length(StageSampleIdx)*2
    
    if(RewardWIdx(idx)-RewardWIdx(idx-1)>0)
        RewardWVector(PreCueSamples+RewardWIdx(idx-1):PreCueSamples+RewardWIdx(idx))=1; %% 1 is Reward. 0 for non-reward
    end;
    
end;

lickdiff = diff(data.response.licks);
BlockStartIndex = find(lickdiff<0);
if size(BlockStartIndex,1) == 2
    BlockStartIndex = [1 BlockStartIndex'];  %%% index of lick data where a new block just started.
else
    BlockStartIndex = [1 BlockStartIndex];
end;

%%
pTarget = data.Params.SwitchProbability;
pNonTarget = 1-data.Params.SwitchProbability;


maxNumBlocks = min(data.Params.NumTrials, size(BlockStartIndex,2));

for iBlock = 1:maxNumBlocks
    
    Ntrial(iBlock)=length(find(data.presentation.stim_times(iBlock,:)>0));  %% number of trials finished during this block
    
    if(Ntrial(iBlock)<=0)
        continue;
    end;
    
    BlockTimeW=[max([data.presentation.stim_times(iBlock,1)-data.Params.durCueDelay-PreCueT,0]),...
        data.presentation.stim_times(iBlock,Ntrial(iBlock))+data.Params.TrialDur-data.Params.durCueDelay-PreCueT]; %% Time window for this block. alligned with stimuli onset.
    
    % BlockSamples=ceil(diff(BlockTimeW)*data.card.ai_fs); %% Total # of samples collected for this block
    
    Bstr=BlockStartIndex(iBlock); %% first index of lickdata in a freshed start block
    if(iBlock+1<=length(BlockStartIndex))
        Bend=BlockStartIndex(iBlock+1)-1;
    else
        Bend=length(data.response.licks);  %% last index of lickdata in a freshed start block
    end;
    
    if( data.Params.extend_iti==0)
        BlocklickIndex=find(data.response.licks(Bstr:Bend)>BlockTimeW(1) & data.response.licks(Bstr:Bend) <BlockTimeW(2));
        BlocklickIndex=BlocklickIndex+Bstr-1;
        
        
        BlockLicksT=data.response.licks(BlocklickIndex)-BlockTimeW(1); %% Time for licks happened during this block
        
        BlockLicksSamples=floor(BlockLicksT*data.card.ai_fs); %% bin lick data according to sample rate
        BlockLicksData{iBlock}=zeros(1,TrialSamples*Ntrial(iBlock));  %% container for lick data for this block
        BlockLicksData{iBlock}(BlockLicksSamples)=1; %% Lick is 1, no Lick is zero for each sample.
        
    else
        BlockLicksData{iBlock}=TrialSegment(Bstr,Bend,PreCueT,data.response.licks,data.card.ai_fs,TrialSamples,Ntrial(iBlock),data.presentation.stim_times(iBlock,:),data.Params); %% Time for licks happened during this block
        
    end;
    
    BlockLicksData{iBlock}=reshape(BlockLicksData{iBlock},TrialSamples,Ntrial(iBlock)); %% reshape it to rows X colomns
    NRewardLicks=sum(BlockLicksData{iBlock}.*repmat(RewardWVector',1,Ntrial(iBlock)),1);   %% number of licks happens during reward window
    IsResTrials=NRewardLicks>= max([1,data.response.lick_threshold]); %% does animal response or not during each trial's rewarding window.
    IsResTrials_= ~IsResTrials;
    
    for mov = 1:length(MoviesToSearch)
        currmov = MoviesToSearch(mov);
        FreMovIndx{mov}{iBlock}  = find(data.Params.Sequence(iBlock,:) == currmov); %% trial index for frequent movie
        
       
        FreMovIndx{mov}{iBlock}(FreMovIndx{mov}{iBlock}>Ntrial(iBlock))=[]; %% remove trials which are not finished
        
        
        FreMovStimOnsetT{iBlock}      = data.presentation.stim_times(iBlock,FreMovIndx{mov}{iBlock});
        NFreMov{mov}(iBlock)          = length(FreMovIndx{mov}{iBlock}); %% number of freq mov trials for this block
        
        FreMovBehav{mov}{iBlock}     = IsResTrials(FreMovIndx{mov}{iBlock});
        FreMovBehavOpp{mov}{iBlock}  = IsResTrials_(FreMovIndx{mov}{iBlock});
        
        LickPSTH{mov}{iBlock,1} = BlockLicksData{iBlock}(:,FreMovIndx{mov}{iBlock}(find(FreMovBehav{mov}{iBlock}==1))); %% CR
        LickPSTH{mov}{iBlock,2} = BlockLicksData{iBlock}(:,FreMovIndx{mov}{iBlock}(find(FreMovBehav{mov}{iBlock}==0))); %% FA
    end
end;

%%

if lightused == 1
    
    for m = 1:length(MoviesToSearch)
        %     if m <= 2
        
        foo  = cell2mat(FreMovIndx{m});
        Laze = AllLaser(foo);
        
        indxOn = find(Laze == 1);
        indxOff = find(Laze == 0);
        
        X = cell2mat(FreMovBehav{m});
        
        if corrflag == 1;
            [XCut, CutPoint] = removeNonRespTrials(X);
            Xon = X(indxOn(indxOn < CutPoint));
            Xoff = X(indxOff(indxOff < CutPoint));
        elseif corrflag == 0;
            
            Xon = X(indxOn);
            Xoff = X(indxOff);
            
        end
        
        NumberCorrectON = length(find(Xon == 1));
        PS.PerCorrectON(m) = NumberCorrectON./length(Xon);
        
        NumberCorrectOFF = length(find(Xoff == 1));
        PS.PerCorrectOFF(m) = NumberCorrectOFF./length(Xoff);
        
        [PS.HR_on, PS.HR_off, PS.FAR_on,PS.FAR_off, PS.d_prime_on, PS.d_prime_off] = getVariables(MoviesToSearch,AllLaser,FreMovIndx,FreMovBehav);
        
        %
%         figure(m);
%         subplot(1,2,1); imagesc(X);
%         subplot(1,2,2); imagesc(XCut);
        %
        %     elseif m >= 3
        %         X = cell2mat(FreMovBehav{m});
        %         NumberCorrect = length(find(X == 1));
        %         PerCorrect(m) = NumberCorrect./length(X);
        %     end;
    end;
    
    %%
    optoClr = [0,191,255]./255;
    
    xax = [0,0.25,0.5,0.75,1];
    figure(1); set(gcf,'color','w');
    plot( xax, PS.PerCorrectON,'-o','markersize',18,'markeredgecolor',optoClr,'markerfacecolor',optoClr,'color',optoClr); hold on;
    plot( xax, PS.PerCorrectOFF,'-o','markersize',18,'markeredgecolor','k','markerfacecolor','k','color','k'); hold on;
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
    
end;


if lightused == 0
    for m = 1:length(MoviesToSearch)
        
        X = cell2mat(FreMovBehav{m});
        NumberCorrect = length(find(X == 1));
        PS.PerCorrect(m) = NumberCorrect./length(X);
    end;
    xax = [0,0.25,0.5,0.75,1];
    figure(1); set(gcf,'color','w');
    plot( xax, PS.PerCorrect,'-o','markersize',18,'markeredgecolor','k','markerfacecolor','k','color','k'); hold on;
    axis square; box off;
    set(gca,'fontsize',18,'fontname','arial','tickdir','out','ticklength',[0.02,0.04]);
end;
