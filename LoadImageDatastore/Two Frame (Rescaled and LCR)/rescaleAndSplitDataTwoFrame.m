%imdsTwoFrameTraining = shuffleCombinedDatastore(imdsTwoFrameTraining);
%imdsTwoFrameValidate = shuffleCombinedDatastore(imdsTwoFrameValidate);


trainingSetOpti = transform(imdsTwoFrameTraining,@processOpti,'IncludeInfo',true);
validationSetOpti = transform(imdsTwoFrameValidate,@processOpti,'IncludeInfo',true);

 trainingSetTwoFrame = transform(imdsTwoFrameTraining,@processTwoFrame,'IncludeInfo',true);
 validationSetTwoFrame = transform(imdsTwoFrameValidate,@processTwoFrame,'IncludeInfo',true);
