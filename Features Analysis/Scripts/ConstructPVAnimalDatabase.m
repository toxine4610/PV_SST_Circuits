function ConstructPVAnimalDatabase

if exist(['../Animal Database/PVAnimalList'],'dir') < 7
    mkdir(['../Animal Database/']);
end;

PVAnimalList{1}.ID   = 'PV-K';
PVAnimalList{1}.Date = '4-Dec-2014';
PVAnimalList{1}.ExptNo = {'1','2'};

PVAnimalList{2}.ID   = 'PV-K';
PVAnimalList{2}.Date = '26-Nov-2014';
PVAnimalList{2}.ExptNo = {'1','2'};

PVAnimalList{3}.ID     = 'PV-J';
PVAnimalList{3}.Date   = '6-Nov-2014';
PVAnimalList{3}.ExptNo = {'2'};

PVAnimalList{4}.ID     = 'PV-I';
PVAnimalList{4}.Date   = '8-Nov-2014';
PVAnimalList{4}.ExptNo = {'1'};

save(['../Animal Database/PVAnimalList'], 'PVAnimalList');
