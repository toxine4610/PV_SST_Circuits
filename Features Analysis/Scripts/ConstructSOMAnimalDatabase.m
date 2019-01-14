function ConstructSOMAnimalDatabase

if exist(['../Animal Database/SOMAnimalList'],'dir') < 7
    mkdir(['../Animal Database/']);
end;

% Animal 1.................................................................
SOMAnimalList{1}.ID   = 'SOM-J';
SOMAnimalList{1}.Date = '6-Nov-2014';
SOMAnimalList{1}.ExptNo = {'4'};

SOMAnimalList{2}.ID     = 'SOM-J';
SOMAnimalList{2}.Date   = '12-Nov-2014';
SOMAnimalList{2}.ExptNo = {'1','3'};

save(['../Animal Database/SOMAnimalList'], 'SOMAnimalList');
