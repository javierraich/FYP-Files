function [outputDs] = shuffleCombinedDatastore(combinedDsInput)

nFiles = length(combinedDsInput.UnderlyingDatastores{1,1}.Files);
RandIndices = randperm(nFiles);

tempDatastore1 = subset(combinedDsInput.UnderlyingDatastores{1,1}, RandIndices);
tempDatastore2 = subset(combinedDsInput.UnderlyingDatastores{1,2}, RandIndices);

outputDs = combine(tempDatastore1, tempDatastore2);

end

