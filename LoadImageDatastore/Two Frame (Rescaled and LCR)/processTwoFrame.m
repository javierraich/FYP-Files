function [dataOut,info] = processTwoFrame(data,info)
 
dataOut = cell(1,2);

targetSize = [227,227];


% imgPresent = data{1,1};
% imgPast = data{1,2};

imgOut = zeros(targetSize(1,1), targetSize(1,2), (2 * size(data{1,1}, 3)), 'uint8');
imgOut(:,:,1:3) = data{1,1};
imgOut(:,:,4:6) = data{1,2};

% Return the label from info struct of the present image (discard past
% image label) as the second column
dataOut(1,:) = {imgOut,info{1,1}.Label(1)};
    
end