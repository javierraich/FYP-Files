params = load("C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\params_2020_02_18__19_50_35.mat");
dataMean = zeros(227,227,6);
dataMean(:,:,1:3) = params.data.Mean;
dataMean(:,:,4:6) = params.data.Mean;


channels = 6; 
inputSize = [227,227,channels]; %change it as you want
lgraph = layerGraph;
input_layer = imageInputLayer(inputSize,'Name','Input_Layer',"Mean",dataMean);
lgraph = addLayers(lgraph,input_layer);



%Code to connect separate streams to two copies of AlexNet

layers = [
    convolution2dLayer([11 11],192,"Name","conv1","BiasLearnRateFactor",2,"Stride",[4 4],"Bias",duplicateLearnable(params.conv1.Bias, 3),"Weights",duplicateLearnable(params.conv1.Weights, [3;4]))
    reluLayer("Name","relu1")
    crossChannelNormalizationLayer(5,"Name","norm1","K",1)
    maxPooling2dLayer([3 3],"Name","pool1","Stride",[2 2])
    groupedConvolution2dLayer([5 5],256,2,"Name","conv2","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",duplicateLearnable(params.conv2.Bias, 3),"Weights",duplicateLearnable(params.conv2.Weights, [3;4]))
    reluLayer("Name","relu2")
    crossChannelNormalizationLayer(5,"Name","norm2","K",1)
    maxPooling2dLayer([3 3],"Name","pool2","Stride",[2 2])
    ];
    


lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'Input_Layer','conv1');


layers = [
    %maxPooling2dLayer([3 3],"Name","pool2_merged","Stride",[2 2])
    convolution2dLayer([3 3],384,"Name","conv3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",params.conv3.Bias,"Weights",duplicateLearnable(params.conv3.Weights, 3))
    reluLayer("Name","relu3")
    groupedConvolution2dLayer([3 3],192,2,"Name","conv4","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",params.conv4.Bias,"Weights",params.conv4.Weights)
    reluLayer("Name","relu4")
    groupedConvolution2dLayer([3 3],128,2,"Name","conv5","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",params.conv5.Bias,"Weights",params.conv5.Weights)
    reluLayer("Name","relu5")
    maxPooling2dLayer([3 3],"Name","pool5","Stride",[2 2])
    batchNormalizationLayer("Name","batchNorm");
    fullyConnectedLayer(1,"Name","fc");
    regressionLayer("Name","regressionOut");
    ];

lgraph = addLayers(lgraph,layers);
 lgraph = connectLayers(lgraph,'pool2','conv3');


miniBatchSize  = 128;
validationFrequency = floor(numel(imdsTwoFrameTraining.UnderlyingDatastores{1,1}.Labels)/miniBatchSize);


    %NOTE - LEARNNING RATE IS LOW AT 0.0001 instead of 0.001 !!
    %Replace later maybe??
    
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',100, ...
    'InitialLearnRate',1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.25, ...
    'LearnRateDropPeriod',10, ...
    'Shuffle','every-epoch', ...
    'ValidationData',validationSetTwoFrame, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ExecutionEnvironment','gpu');

trainedNnet = trainNetwork(trainingSetTwoFrame,lgraph,options);

% h= findall(groot,'Type','Figure');
% h.MenuBar = 'figure';