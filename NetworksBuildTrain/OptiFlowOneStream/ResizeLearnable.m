function [outputLearnable] = ResizeLearnable(learnable,dimensions)

learnableDims = size(learnable);

diffDimensions = dimensions' - learnableDims;

outputLearnable = padarray(learnable,diffDimensions,0,'post');


end

