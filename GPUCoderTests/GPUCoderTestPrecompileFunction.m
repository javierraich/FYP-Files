function [predictedDistance] = GPUCoderTestPrecompileFunction(img)

persistent detectionnet;
if isempty(detectionnet)   
    detectionnet = coder.loadDeepLearningNetwork('trainedNnet.mat','Regressor');
end

predictedDistance = predict(detectionnet, img);