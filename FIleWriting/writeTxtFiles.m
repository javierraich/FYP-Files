filesPresent = imdsTwoFrameTraining.UnderlyingDatastores{1,1}.Files;
filesPast = imdsTwoFrameTraining.UnderlyingDatastores{1,2}.Files;

fileID = fopen('presentListTraining.txt','w');

for i = 1:size(filesPresent, 1)
    fprintf(fileID,'%s\n',filesPresent{i,1});
end

fclose(fileID);

fileID = fopen('pastListTraining.txt','w');

for i = 1:size(filesPast, 1)
    fprintf(fileID,'%s\n',filesPast{i,1});
end

fclose(fileID);

filesPresent = imdsTwoFrameValidate.UnderlyingDatastores{1,1}.Files;
filesPast = imdsTwoFrameValidate.UnderlyingDatastores{1,2}.Files;

fileID = fopen('presentListValidate.txt','w');

for i = 1:size(filesPresent, 1)
    fprintf(fileID,'%s\n',filesPresent{i,1});
end

fclose(fileID);

fileID = fopen('pastListValidate.txt','w');

for i = 1:size(filesPast, 1)
    fprintf(fileID,'%s\n',filesPast{i,1});
end

fclose(fileID);