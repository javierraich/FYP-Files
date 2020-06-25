function stop = shuffleMidTraining(info,N)

stop = false;



% Clear the variables when training starts.
if mod(info.Iteration, N) == 1 
    %Shuffle
    %print("SHUFFLING")
    global globalTraining
    
    nFiles = length(globalTraining.UnderlyingDatastore.UnderlyingDatastores{1,1}.Files);
    RandIndices = randperm(nFiles);
    
    
    tempDatastore1 = subset(globalTraining.UnderlyingDatastore.UnderlyingDatastores{1,1}, RandIndices);
    tempDatastore2 = subset(globalTraining.UnderlyingDatastore.UnderlyingDatastores{1,2}, RandIndices);
    
    combinedDS = combine(tempDatastore1, tempDatastore2);
    
    globalTraining = transform(combinedDS,@processTwoFrame,'IncludeInfo',true);
    
%     globalTraining.UnderlyingDatastore.UnderlyingDatastores{1,1} = subset(globalTraining.UnderlyingDatastore.UnderlyingDatastores{1,1}, RandIndices);
%     globalTraining.UnderlyingDatastore.UnderlyingDatastores{1,2} = subset(globalTraining.UnderlyingDatastore.UnderlyingDatastores{1,2}, RandIndices);

    
end

end