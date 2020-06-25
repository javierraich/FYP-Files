%RECALL USE UNSHUFFLED 4_APART DATASTORE

%TRAINING SET

framePresentTraining = imdsTwoFrameTraining.UnderlyingDatastores{1,1};

%Make second datastore with .Mat files

fdsLeft = fileDatastore("C:\Users\Javier R\Desktop\FYPFiles\Flownet2\CalculatedFlows\TrainingLeft",'ReadFcn',@load,'FileExtensions','.mat');
fdsCenter = fileDatastore("C:\Users\Javier R\Desktop\FYPFiles\Flownet2\CalculatedFlows\TrainingCenter",'ReadFcn',@load,'FileExtensions','.mat');
fdsRight = fileDatastore("C:\Users\Javier R\Desktop\FYPFiles\Flownet2\CalculatedFlows\TrainingRight",'ReadFcn',@load,'FileExtensions','.mat');

fds = fdsCenter;
fds.Files = cat(1,fds.Files, fdsLeft.Files, fdsRight.Files);


%Create combined datastore with frame + .mat files in order
frameOptiTraining = combine(framePresentTraining, fds);

%Shuffle
frameOptiTraining = shuffleOptiDatastore(frameOptiTraining);


%Create transformed datastore to output correct 5 channel output (think
%about the multiplying factor as well)

trainingSetFlownet = transform(frameOptiTraining,@matFileOptiProcess,'IncludeInfo',true);


%VALIDATION SET

framePresentValidate = imdsTwoFrameValidate.UnderlyingDatastores{1,1};


%framePresentValidate.Files = setdiff(framePresentValidate.Files,framePresentValidate.Files{1,1});

%Make second datastore with .Mat files

fdsLeft2 = fileDatastore("C:\Users\Javier R\Desktop\FYPFiles\Flownet2\CalculatedFlows\ValidationLeft",'ReadFcn',@load,'FileExtensions','.mat');
fdsCenter2 = fileDatastore("C:\Users\Javier R\Desktop\FYPFiles\Flownet2\CalculatedFlows\ValidationCenter",'ReadFcn',@load,'FileExtensions','.mat');
fdsRight2 = fileDatastore("C:\Users\Javier R\Desktop\FYPFiles\Flownet2\CalculatedFlows\ValidationRight",'ReadFcn',@load,'FileExtensions','.mat');

fds2 = fdsCenter2;
fds2.Files = cat(1,fds2.Files, fdsLeft2.Files, fdsRight2.Files);


%Create combined datastore with frame + .mat files in order
frameOptiValidate = combine(framePresentValidate, fds2);

%Create transformed datastore to output correct 5 channel output (think
%about the multiplying factor as well)

validationSetFlownet = transform(frameOptiValidate,@matFileOptiProcess,'IncludeInfo',true);