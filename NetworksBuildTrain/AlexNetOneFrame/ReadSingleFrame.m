trainingSetSingle = imdsTwoFrameTraining.UnderlyingDatastores{1,1};
validationSetSingle = imdsTwoFrameValidate.UnderlyingDatastores{1,1};

packedTrainingSingle = transform(trainingSetSingle,@packSingle,'IncludeInfo',true);
packedValidationSingle = transform(validationSetSingle,@packSingle,'IncludeInfo',true);