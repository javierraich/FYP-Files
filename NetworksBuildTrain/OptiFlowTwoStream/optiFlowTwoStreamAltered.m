params = load("C:\Users\Javier R\Desktop\FYPFiles\FYPScripts\params_2020_02_18__19_50_35.mat");
dataMean = zeros(227,227,6);
dataMean(:,:,1:3) = params.data.Mean;
dataMean(:,:,4:6) = params.data.Mean;


%Took this code from stackoverflow answer

channels = 5; 
inputSize = [227,227,channels]; %change it as you want
lgraph = layerGraph;


%input_layer = imageInputLayer(inputSize,'Name','Input_Layer','Normalization', 'none');

input_layer = imageInputLayer(inputSize,'Name','Input_Layer','Normalization', 'rescale-zero-one');

lgraph = addLayers(lgraph,input_layer);
for i = 1 : channels
    eval(sprintf('ch_%d_splitter = convolution2dLayer(1,1,''Name'',''channel_%d_splitter'',''WeightLearnRateFactor'',0,''BiasLearnRateFactor'',0,''WeightL2Factor'',0,''BiasL2Factor'',0);',i,i));
    eval(sprintf('ch_%d_splitter.Weights = zeros(1,1,channels,1);',i));
    eval(sprintf('ch_%d_splitter.Weights(1,1,%d,1) = 1;',i,i));
    eval(sprintf('ch_%d_splitter.Bias = zeros(1,1,1,1);',i));
    eval(sprintf('lgraph = addLayers(lgraph,ch_%d_splitter);',i));
    eval(sprintf('lgraph = connectLayers(lgraph,''Input_Layer'',''channel_%d_splitter'');',i));
end
%Here, let's assume you want to use the first three layers as input for
%the first stream and the last two layers as input for second stream
input_stream_1 = depthConcatenationLayer(3,'Name','input_stream_1');
lgraph = addLayers(lgraph,input_stream_1);
input_stream_2 = depthConcatenationLayer(2,'Name','input_stream_2');
lgraph = addLayers(lgraph,input_stream_2);
lgraph = connectLayers(lgraph,'channel_1_splitter','input_stream_1/in1');
lgraph = connectLayers(lgraph,'channel_2_splitter','input_stream_1/in2');
lgraph = connectLayers(lgraph,'channel_3_splitter','input_stream_1/in3');
lgraph = connectLayers(lgraph,'channel_4_splitter','input_stream_2/in1');
lgraph = connectLayers(lgraph,'channel_5_splitter','input_stream_2/in2');


%Code to connect separate streams to two copies of AlexNet

layers = [
    convolution2dLayer([11 11],96,"Name","conv1","BiasLearnRateFactor",2,"Stride",[4 4],"Bias",params.conv1.Bias,"Weights",params.conv1.Weights)
    reluLayer("Name","relu1")
    crossChannelNormalizationLayer(5,"Name","norm1","K",1)
    maxPooling2dLayer([3 3],"Name","pool1","Stride",[2 2])
    groupedConvolution2dLayer([5 5],128,2,"Name","conv2","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",params.conv2.Bias,"Weights",params.conv2.Weights)
    reluLayer("Name","relu2")
    crossChannelNormalizationLayer(5,"Name","norm2","K",1)
    maxPooling2dLayer([3 3],"Name","pool2","Stride",[2 2])
    ];
    


lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'input_stream_1','conv1');

layers = [
    convolution2dLayer([11 11],96,"Name","S2_conv1","BiasLearnRateFactor",2,"Stride",[4 4])
    reluLayer("Name","S2_relu1")
    crossChannelNormalizationLayer(5,"Name","S2_norm1","K",1)
    maxPooling2dLayer([3 3],"Name","S2_pool1","Stride",[2 2])
    groupedConvolution2dLayer([5 5],128,2,"Name","S2_conv2","BiasLearnRateFactor",2,"Padding",[2 2 2 2], "Bias",params.conv2.Bias,"Weights",params.conv2.Weights)
    reluLayer("Name","S2_relu2")
    crossChannelNormalizationLayer(5,"Name","S2_norm2","K",1)
    maxPooling2dLayer([3 3],"Name","S2_pool2","Stride",[2 2])
    ];
    

lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'input_stream_2','S2_conv1');

layers = [
    depthConcatenationLayer(2,'Name','StreamMergingConcatenation')
];

lgraph = addLayers(lgraph,layers);

 lgraph = connectLayers(lgraph,'pool2','StreamMergingConcatenation/in1');
 lgraph = connectLayers(lgraph,'S2_pool2','StreamMergingConcatenation/in2');

 %lgraph = connectLayers(lgraph,'norm2','StreamMergingConcatenation/in1');
 %lgraph = connectLayers(lgraph,'S2_norm2','StreamMergingConcatenation/in2');

layers = [
    %maxPooling2dLayer([3 3],"Name","pool2_merged","Stride",[2 2])
    convolution2dLayer([3 3],384,"Name","conv3","BiasLearnRateFactor",2,"Padding",[1 1 1 1])
    reluLayer("Name","relu3")
    groupedConvolution2dLayer([3 3],192,2,"Name","conv4","BiasLearnRateFactor",2,"Padding",[1 1 1 1])
    reluLayer("Name","relu4")
    groupedConvolution2dLayer([3 3],128,2,"Name","conv5","BiasLearnRateFactor",2,"Padding",[1 1 1 1])
    reluLayer("Name","relu5")
    maxPooling2dLayer([3 3],"Name","pool5","Stride",[2 2])
    %batchNormalizationLayer("Name","batchNorm");
    fullyConnectedLayer(1,"Name","fc");
    maeRegressionLayer('mae');
    ];

lgraph = addLayers(lgraph,layers);
%lgraph = connectLayers(lgraph,'StreamMergingConcatenation','pool2_merged');
lgraph = connectLayers(lgraph,'StreamMergingConcatenation','conv3');


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
    'ValidationData',validationSetOpti, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ExecutionEnvironment','gpu');

trainedNnet = trainNetwork(trainingSetOpti,lgraph,options);

%h= findall(groot,'Type','Figure');
%h.MenuBar = 'figure';