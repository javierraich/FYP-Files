targetSize = [227,227];  


for i = 400:732
      
    topLevelPathOrig = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor', ...
     ('exp'+string(i)));
 
    topLevelPathWrite = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Center', ...
     ('exp'+string(i)));
 
    if exist((fullfile(topLevelPathOrig, 'lab_C.mat')), 'file')
         
         
        mkdir(topLevelPathWrite)

        imdsExp = imageDatastore(topLevelPathOrig);
        
        copyfile(fullfile(topLevelPathOrig, 'lab_C.mat'),fullfile(topLevelPathWrite, 'lab_C.mat'));

        counter = 0;

        while hasdata(imdsExp)
           img = read(imdsExp);
           imgCenter = imresize(img(1:360, 141:500,:),targetSize);

           fileName = strcat(('exp'+string(i)), '_img',num2str(counter, '%03.f'),'.jpg');
           imwrite(imgCenter, fullfile(topLevelPathWrite, fileName));
           counter = counter + 1;
        end
        
    end
    
end