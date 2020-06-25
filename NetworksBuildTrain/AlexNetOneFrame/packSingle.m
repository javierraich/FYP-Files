function [dataOut,info] = packSingle(data,info)
 
dataOut = cell(1,2);

targetSize = [227,227];


% imgPresent = data{1,1};
% imgPast = data{1,2};

imgOut = data;

% Return the label from info struct of the present image (discard past
% image label) as the second column
dataOut(1,:) = {imgOut,info.Label(1)};
    
end