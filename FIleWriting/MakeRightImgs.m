targetSize = [227,227];  


for i = 400:732
      
    topLevelPathOrig = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor', ...
     ('exp'+string(i)));
 
    topLevelPathWrite = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Right', ...
     ('exp'+string(i)));
 
    if exist((fullfile(topLevelPathOrig, 'lab_R.mat')), 'file')
         
         
        mkdir(topLevelPathWrite)

        imdsExp = imageDatastore(topLevelPathOrig);
        
        copyfile(fullfile(topLevelPathOrig, 'lab_R.mat'),fullfile(topLevelPathWrite, 'lab_R.mat'));

        counter = 0;

        while hasdata(imdsExp)
           img = read(imdsExp);
           imgRight = imresize(img(1:360, 281:640,:),targetSize);

           fileName = strcat(('exp'+string(i)), '_img',num2str(counter, '%03.f'),'.jpg');
           imwrite(imgRight, fullfile(topLevelPathWrite, fileName));
           counter = counter + 1;
        end
        
    end
    
end