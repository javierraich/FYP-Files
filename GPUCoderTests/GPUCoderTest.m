%Remember to change CUDA path before and after executing this.
%CUDA_PATH variable to 10.1 from 9.2
%In path variable we remove
%C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.2\bin
%and
%C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.2\libnvvp
%Recall these were at the top of the path variable


%This fragment of code generates the GPU Code
%Copy trainedNnet to current directory before running!!

cfg = coder.gpuConfig('mex');
cfg.TargetLang = 'C++';
cfg.DeepLearningConfig = coder.DeepLearningConfig('cudnn');

%Two Frame
% codegen -config cfg GPUCoderTestPrecompileFunction -args {ones(227,227,6, 'single')} -report

%Optical Flow
codegen -config cfg GPUCoderTestPrecompileFunction -args {ones(227,227,5, 'single')} -report

%One Frame
% codegen -config cfg GPUCoderTestPrecompileFunction -args {ones(227,227,3, 'single')} -report


%SINGLE IMAGE TEST AND DISPLAY
%  testData = validationSetTwoFrame.read;
%  testImg = testData{1,1}(:,:,1:3);
%  testLabel = testData{1,2};
% 
%  predictedLabel = GPUCoderTestPrecompileFunction_mex(testImg);
% 
% 
%  figure
%  imshow(testImg)
%  title(strcat('Prediction  ', string(predictedLabel), ' Truth   ', string(testLabel)))

%data = validationSetTwoFrame.readall;

numValidation = numel(validationSetSingle.Labels);

predictedDistances = zeros(numValidation, 1);
trueDistances = zeros(numValidation, 1);
errorDistances = zeros(numValidation, 1);

accumTime = 0;

validationSetTwoFrame.reset;
validationSetOpti.reset;

%comment this out if not single frame test
%packedValidationSingle.reset;

for i = 1 : numValidation
    %Two Frame
%     data = read(validationSetTwoFrame);
%     data{1,1} = single(data{1,1});
        
    %Optical Flow
    data = read(validationSetOpti);
    
    %One Frame
    %data = read(packedValidationSingle);
    %data{1,1} = single(data{1,1});

    
    tic
    predictedDistances(i,1) = GPUCoderTestPrecompileFunction_mex(data{1,1});
    t = toc;
    
    accumTime = accumTime + t; 
    
    trueDistances(i,1) = data{1,2};
    errorDistances(i,1) = predictedDistances(i,1) - data{1,2};
end

x = 0:0.1:0.6;
y = 0:0.1:0.6;

figure
hold on
scatter(trueDistances,predictedDistances)
plot(x,y);
hold off

xlabel('Sensor Distance')
ylabel('Predicted Distance')

% RMSE = sqrt(mean(errorDistances.^2))

