net = alexnet;
core = net.Layers;

%For Trial Without Normalisation.
%core(1,1) = imageInputLayer([227 227 3], 'Normalization', 'none');

%For Trial With zerocenter (proper) Normalisation.
%core(1,1) = imageInputLayer([227 227 3], 'Normalization', 'zerocenter');

%For Trial with zeroone normalisation
core(1,1) = imageInputLayer([227 227 3], 'Normalization', 'rescale-zero-one', 'Max', 255, 'Min', 0);



%With batch normalisation
% core((20:25),:) = [];
% core(17,1) = batchNormalizationLayer;
% core(18,1) = fullyConnectedLayer(1);
% core(19,1) = regressionLayer;

%Without batch normalisation
 core((19:25),:) = [];
 core(17,1) = fullyConnectedLayer(1);
 
 %non-mae
 %core(18,1) = regressionLayer;
 
 %mae
 core(18,1) = maeRegressionLayer('mae');


%Without pre-trained Weights:
% core(2,1).Weights = [];
% core(2,1).Bias = [];
% 
% core(6,1).Weights = [];
% core(6,1).Bias = [];
% 
% core(10,1).Weights = [];
% core(10,1).Bias = [];
% 
% core(12,1).Weights = [];
% core(12,1).Bias = [];
% 
% core(14,1).Weights = [];
% core(14,1).Bias = [];


trainingSet = imdsTwoFrameTraining.UnderlyingDatastores{1,1};
validationSet = imdsTwoFrameValidate.UnderlyingDatastores{1,1};


miniBatchSize  = 128;
validationFrequency = floor(numel(trainingSet.Labels)/miniBatchSize);



    %NOTE - LEARNNING RATE IS LOW AT 0.0001 instead of 0.001 !!
    %Replace later maybe??
    

options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',35, ...
    'InitialLearnRate',1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.25, ...
    'LearnRateDropPeriod',10, ...
    'Shuffle','never', ...
    'ValidationData',packedValidationSingle, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ExecutionEnvironment','gpu');

trainedNnet = trainNetwork(packedTrainingSingle,core,options);

%h= findall(groot,'Type','Figure');
%h.MenuBar = 'figure';
