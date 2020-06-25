function [dataOut,info] = matFileOptiProcess(data,info)
 
dataOut = cell(1,2);

targetSize = [227,227];


img = data{1,1};

opticalFlow = data{1,2};


infoOut = zeros(targetSize(1,1), targetSize(1,2), (size(data{1,1}, 3) + 2), 'single');
infoOut(:,:,1:3) = img(1:targetSize(1,1), 1:targetSize(1,2), :);

%max on optical flow values for dataset yields value around 9 (slightly below
%10), we rescale this to be of order similar to RGB inputs.

%12.8 such that optical flow is approximately bounded by -128 and 128.

infoOut(:,:,4) = opticalFlow.X(1:targetSize(1,1), 1:targetSize(1,2)) * 12.8;
infoOut(:,:,5) = opticalFlow.Y(1:targetSize(1,1), 1:targetSize(1,2)) * 12.8;

% Return the label from info struct of the present image (discard past
% image label) as the second column
dataOut(1,:) = {infoOut,info{1,1}.Label(1)};
    
end