%% load data
function [PerCorrect,  LickPSTH] = getBehavData(Data)

PreCueT=0.5; %% time window before sound cue.
PreCueSamples=PreCueT*data.card.ai_fs;
%%
FreMov=data.Params.NonPunishedMov;
OddMov=data.Params.PunishedMov;
TrialSamples=(data.Params.TrialDur+PreCueT)*data.card.ai_fs; %% # of samples per trial
RewardWVector=zeros(1,TrialSamples);
StageSampleIdx=round([0,data.Params.durCueDelay,data.Params.durCueDelay+data.Params.durStim,data.Params.TrialDur-data.Params.durBlank]*data.card.ai_fs); %% sample index for onset of each stage

%%% RewardWIdx is the time window when mouse can get reward if it licks.
RewardWIdx=round(data.response.reward_window*data.card.ai_fs); %% reward Windows  in unit of sample index relative to onset of each stage
RewardWIdx=RewardWIdx+repmat(StageSampleIdx,2,1); %% reward window in unit of sample index relative to onset of trial
for idx=2:2:length(StageSampleIdx)*2
    if(RewardWIdx(idx)-RewardWIdx(idx-1)>0)
        RewardWVector(PreCueSamples+RewardWIdx(idx-1):PreCueSamples+RewardWIdx(idx))=1; %% 1 is Reward. 0 for non-reward
    end;
end;

lickdiff=diff(data.response.licks);
BlockStartIndex=find(lickdiff<0);
BlockStartIndex=[1 BlockStartIndex];  %%% index of lick data where a new block just started.

%%
for iBlock=1:data.Params.NumTrials
    
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
    IsResTrials_=~IsResTrials;
    
    %% frequent trials
    FreMovIndx{iBlock}=find(data.Params.Sequence(iBlock,:)==FreMov); %% trial index for frequent movie
    FreMovIndx{iBlock}(FreMovIndx{iBlock}>Ntrial(iBlock))=[]; %% remove trials which are not finished
    FreMovStimOnsetT{iBlock}=data.presentation.stim_times(iBlock,FreMovIndx{iBlock});
    NFreMov(iBlock)=length(FreMovIndx{iBlock}); %% number of freq mov trials for this block
    FreMovBehav{iBlock}=IsResTrials_(FreMovIndx{iBlock}); %% behaviour outcome for frequent movie: 1 CR. 0 FA
    BehaviourRate(iBlock,1)=sum(FreMovBehav{iBlock})/length(FreMovIndx{iBlock}); %% CR rate
    
    %% odd ball trials
    OddMovIndx{iBlock}=find(data.Params.Sequence(iBlock,:)==OddMov); %% trial index for odd movie
    OddMovIndx{iBlock}(OddMovIndx{iBlock}>Ntrial(iBlock))=[]; %% remove trials which are not finished
    OddMovStimOnsetT{iBlock}=data.presentation.stim_times(iBlock,OddMovIndx{iBlock});
    NOddMov(iBlock)=length(OddMovIndx{iBlock}); %% number of odd mov trials for this block
    OddMovBehav{iBlock}=IsResTrials(OddMovIndx{iBlock}); %% behaviour outcome for odd movie: 1 HIT. 0 MISS
    BehaviourRate(iBlock,2)=sum(OddMovBehav{iBlock})/length(OddMovIndx{iBlock}); %% Hit rate
    
    
    LickPSTH{iBlock,1}=BlockLicksData{iBlock}(:,FreMovIndx{iBlock}(find(FreMovBehav{iBlock}==1))); %% CR
    LickPSTH{iBlock,2}=BlockLicksData{iBlock}(:,FreMovIndx{iBlock}(find(FreMovBehav{iBlock}==0))); %% FA
    
    LickPSTH{iBlock,3}=BlockLicksData{iBlock}(:,OddMovIndx{iBlock}(find(OddMovBehav{iBlock}==1))); %% HIT
    LickPSTH{iBlock,4}=BlockLicksData{iBlock}(:,OddMovIndx{iBlock}(find(OddMovBehav{iBlock}==0))); %% MISS
    
    
    fprintf('\nMouse %s: Block %d. Total trials %d',data.mouse, iBlock,Ntrial(iBlock));
    fprintf('\nHit: %.2f%% %d of %d trials \nCR:  %.2f%% %d of %d trials\n',...
        BehaviourRate(iBlock,2)*100,sum(OddMovBehav{iBlock}),length(OddMovIndx{iBlock}),...
        BehaviourRate(iBlock,1)*100,sum(FreMovBehav{iBlock}),length(FreMovIndx{iBlock}));
    
end;

%%
NumberofHitTrials = 0;
for i = 1:size(OddMovBehav,2);
    NumberofHitTrials = NumberofHitTrials + sum(OddMovBehav{i}) ;
end;

NumberofCRTrials = 0;
for i = 1:size(OddMovBehav,2);
    NumberofCRTrials = NumberofCRTrials + sum(FreMovBehav{i}) ;
end;

TotalNumberofTrials = 0;
for i = 1:size(OddMovBehav,2);
   TotalNumberofTrials = TotalNumberofTrials + Ntrial(i) ;
end;

PerCorrect = 100.*( (NumberofCRTrials+NumberofHitTrials)/TotalNumberofTrials );

% %% Raster plot for each condtion.
% %%% Freqmov-incorrect, Frqmov-correct,Odd-incorrect,Odd-correct
% TotalTrial=sum(Ntrial)
% 
% Hitdata=[];
% Missdata=[];
% CRdata=[];
% FAdata=[];
% for iBlock=1:data.Params.NumTrials
%     if(Ntrial(iBlock)<=0)
%         continue;
%     end;
%     curdata=BlockLicksData{iBlock};
%     FreIdx=FreMovIndx{iBlock};
%     OddIdx=OddMovIndx{iBlock};
%     
%     Fredata=curdata(:,FreIdx);
%     Odddata=curdata(:,OddIdx);
%     
%     Hitdata=[Hitdata,Odddata(:,find(OddMovBehav{iBlock}==1))];
%     Missdata=[Missdata,Odddata(:,find(OddMovBehav{iBlock}==0))];
%     
%     CRdata=[CRdata,Fredata(:,find(FreMovBehav{iBlock}==1))];
%     FAdata=[FAdata,Fredata(:,find(FreMovBehav{iBlock}==0))];
% end;
% TotalData=[Hitdata,Missdata,FAdata,CRdata];
% TotalData=logical(TotalData);
% 
% LineFormatHorz.LineWidth = 5;
% LineFormatHorz.Color = 'b';
% LineFormatVert.LineWidth = 5;
% MarkerFormat.MarkerSize = 12;
% MarkerFormat.Marker = '.';
% MarkerFormat.color = 'b';
% h=figure;
% plotSpikeRaster(TotalData','PlotType','scatter','MarkerFormat',MarkerFormat,'TimePerBin',1/data.card.ai_fs);
% 
% Xtics_time=PreCueT+data.Params.durCueDelay+[0,data.Params.durStim,data.Params.durStim+data.Params.durResponse];
% Xtics_sample=round(Xtics_time*data.card.ai_fs);
% 
% for i=1:length(Xtics_time)    
%     XticLabel{i}=num2str(Xtics_time(i)-PreCueT-data.Params.durCueDelay);
% end;
% set(gca,'XTick',Xtics_sample,'XTicklabel',XticLabel);
% xlabel('Time(s)');
% ylabel('Trial');
% hold on;
% YL=ylim;
% XL=xlim;
% 
% line([XL(1) XL(2)],[size(Hitdata,2),size(Hitdata,2)],'LineStyle','--','Color','r','Linewidth',1.0);
% line([XL(1) XL(2)],[size(Hitdata,2)+size(Missdata,2),size(Hitdata,2)+size(Missdata,2)],'LineStyle','--','Color','r','Linewidth',1.0);
% line([XL(1) XL(2)],[size(Hitdata,2)+size(Missdata,2)+size(FAdata,2),size(Hitdata,2)+size(Missdata,2)+size(FAdata,2)],'LineStyle','--','Color','r','Linewidth',1.0);
% 
% 
% for i=1:length(Xtics_sample)
%     line([Xtics_sample(i) Xtics_sample(i)],[YL(1) YL(2)],'LineStyle','--','Color','k','Linewidth',2.0);
% end;
% 
% Strs=[data.mouse,' on ',data.Expdate,'_raster'];
% saveas(h,[Strs,'.fig'],'fig');


%%
SmthW=20;
SmthStd=5;
ConName={'CR','FA','HIT','MISS'};
ConColor={'g','b','r','m'};
%% Visualization
%%% Timecourse of lick
Timeidx=(0:TrialSamples-1)/data.card.ai_fs-data.Params.durCueDelay-PreCueT;
h = figure('Name',['Mouse:',data.mouse]);clf;
for iBlock=1: data.Params.NumTrials
    if(Ntrial(iBlock)<=0)
        continue;
    end;
    
    subplot(2,1,iBlock);hold on;
    for iSub=1:4,
        
        %     plot(Timeidx,mean(LickPSTH_sm{iBlock,iSub},2),'color',ConColor{iSub},'linewidth',2.5);
        LickPSTH_mean=mean(LickPSTH{iBlock,iSub},2)*data.card.ai_fs;
        %       plot(Timeidx,smoothts(mean(LickPSTH{iBlock,iSub},2)','g',SmthW,SmthStd),'color',ConColor{iSub},'linewidth',2.5);
        plot(Timeidx,smoothts(LickPSTH_mean','g',SmthW,SmthStd),'color',ConColor{iSub},'linewidth',2.5);
        
    end;
    theLegend={['CR:',num2str( BehaviourRate(iBlock,1)*100,3),'%'],['FA:',num2str((1- BehaviourRate(iBlock,1))*100,3),'%'],...
        ['Hit:',num2str( BehaviourRate(iBlock,2)*100,3),'%'],['MISS:',num2str((1- BehaviourRate(iBlock,2))*100,3),'%']};
    legend(theLegend);
    hold on;
    YL=ylim;
    
    
    CueOnset=-data.Params.durCueDelay;
    StimOffset=data.Params.durStim;
    ResponseWOffset=data.Params.durStim+data.Params.durResponse;
    
    line([CueOnset CueOnset],[YL(1) YL(2)],'LineStyle','--','Color','k','Linewidth',2.0);
    line([0 0],[YL(1) YL(2)],'LineStyle','--','Color','k','Linewidth',2.0);
    line([StimOffset StimOffset],[YL(1) YL(2)],'LineStyle','--','Color','k','Linewidth',2.0);
    line([ResponseWOffset ResponseWOffset],[YL(1) YL(2)],'LineStyle','--','Color','k','Linewidth',2.0);
    xlabel('Time (s)');
    ylabel('Lick Rate (Hz)');
    Strs=[data.mouse,' on ',data.Expdate,' Block',num2str(iBlock)];
    title(Strs);
    
    
end;

if saveFlag == 1
    Strs=[data.mouse,' on ',data.Expdate,'_PSTH'];
    saveas(h,[Strs,'.fig'],'fig');
end;




