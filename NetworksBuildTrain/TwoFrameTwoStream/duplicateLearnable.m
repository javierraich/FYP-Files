function [duplicatedLearnable] = duplicateLearnable(originalLearnable)


sizeOfOriginal = size(originalLearnable);
numberOfDims = size(sizeOfOriginal,2);
repetitionFactorPerDim = ones(numberOfDims,1);

repetitionFactorPerDim(3,1) = 2;

%repetitionFactorPerDim((numberOfDims-1),1) = 2;

duplicatedLearnable = repmat (originalLearnable, repetitionFactorPerDim');


% duplicatedLearnable = zeros((size(originalLearnable,1)), ...
%     (size(originalLearnable,2)), (size(originalLearnable,3) * 2), (size(originalLearnable,4)));
% 
% 
% originalSize = size(originalLearnable,3);
% 
% duplicatedLearnable(:, :, 1:originalSize, :) = originalLearnable;
% duplicatedLearnable(:, :, originalSize+1:end, :) = originalLearnable;
