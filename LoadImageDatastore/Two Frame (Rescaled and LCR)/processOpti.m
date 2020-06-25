function [dataOut,info] = processOpti(data,info)
 
dataOut = cell(1,2);

targetSize = [227,227];


 imgPresent = data{1,1};
 imgPast = data{1,2};



infoOut = zeros(targetSize(1,1), targetSize(1,2), (size(data{1,1}, 3) + 2), 'single');
infoOut(:,:,1:3) = imgPast;

%opticFlow = opticalFlowLK('NoiseThreshold',0.005);

%opticFlow = opticalFlowFarneback;

opticFlow = opticalFlowHS;

imgPastGray = rgb2gray(imgPast);
imgPresentGray = rgb2gray(imgPresent);

flow = estimateFlow(opticFlow,imgPastGray);

% tic
% for i = 1:1000
%     flow = estimateFlow(opticFlow,imgPresentGray);
% end
% toc

%max on optical flow values for dataset yields value around 9 (slightly below
%10), we rescale this to be of order similar to RGB inputs.

%12.8 such that optical flow is approximately bounded by -128 and 128.

infoOut(:,:,4) = flow.Vx * 12.8;
infoOut(:,:,5) = flow.Vy * 12.8;

% Return the label from info struct of the present image (discard past
% image label) as the second column
dataOut(1,:) = {infoOut,info{1,1}.Label(1)};
    
end