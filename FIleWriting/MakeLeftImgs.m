targetSize = [227,227];  


for i = 400:732
      
    topLevelPathOrig = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor', ...
     ('exp'+string(i)));
 
    topLevelPathWrite = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Left', ...
     ('exp'+string(i)));
 
    if exist((fullfile(topLevelPathOrig, 'lab_L.mat')), 'file')
         
         
        mkdir(topLevelPathWrite)

        imdsExp = imageDatastore(topLevelPathOrig);
        
        copyfile(fullfile(topLevelPathOrig, 'lab_L.mat'),fullfile(topLevelPathWrite, 'lab_L.mat'));

        counter = 0;

        while hasdata(imdsExp)
           img = read(imdsExp);
           imgLeft = imresize(img(1:360, 1:360,:),targetSize);

           fileName = strcat(('exp'+string(i)), '_img',num2str(counter, '%03.f'),'.jpg');
           imwrite(imgLeft, fullfile(topLevelPathWrite, fileName));
           counter = counter + 1;
        end
        
    end
    
end