function [outputDs] = shuffleOptiDatastore(combinedDsInput)

nFiles = length(combinedDsInput.UnderlyingDatastores{1,1}.Files);
RandIndices = randperm(nFiles);

tempDatastore1 = imageDatastore("C:\Users\Javier R\Desktop\netStruct.PNG");

%tempDatastore1 = subset(combinedDsInput.UnderlyingDatastores{1,1}, RandIndices);

tempDatastore2 = fileDatastore("C:\Users\Javier R\Desktop\FYPFiles\Flownet2\CalculatedFlows\TrainingLeft",'ReadFcn',@load,'FileExtensions','.mat');

%zeroArr = zeros(nFiles,1);
zeroCell = cell(nFiles,1);
zeroCellFrame = cell(nFiles,1);

labels = zeros(nFiles,1);

oldLabels = combinedDsInput.UnderlyingDatastores{1,1}.Labels;

underLying2Files = combinedDsInput.UnderlyingDatastores{1,2}.Files;
underLying1Files = combinedDsInput.UnderlyingDatastores{1,1}.Files;

for i = 1:nFiles
    %zeroCell{i,1} = combinedDsInput.UnderlyingDatastores{1,2}.Files(RandIndices(1,i));
    zeroCell(i,1) = underLying2Files(RandIndices(1,i));
    zeroCellFrame(i,1) = underLying1Files(RandIndices(1,i));
    labels(i,1) = oldLabels(RandIndices(1,i));
end

tempDatastore2.Files = zeroCell;
tempDatastore1.Files = zeroCellFrame;
tempDatastore1.Labels = labels;

%tempDatastore2 = subset(combinedDsInput.UnderlyingDatastores{1,2}, RandIndices);

outputDs = combine(tempDatastore1, tempDatastore2);

end


