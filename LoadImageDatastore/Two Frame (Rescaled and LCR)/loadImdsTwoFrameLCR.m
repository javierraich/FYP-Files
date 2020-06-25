%Determining random experiments to allocate to training and validation (80%
%and 20% split)

% r1 = randperm(333,floor(333/5));
% r1 = sort(r1);
% r1 = r1 + 399;

framesApart = 4; 


load Indices_Validation.mat

%LEFT
%First manual initialisation of the datastores

 topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Left', ...
  ('exp'+string(400)));
 
 topLeftPresentTrain = imageDatastore(topLevelPath);
 
 for i = 1:1:framesApart
      topLeftPresentTrain.Files = setdiff(topLeftPresentTrain.Files,topLeftPresentTrain.Files{1,1});
 end
 
 labels = importdata(fullfile(topLevelPath, 'lab_L.mat'));
 labels = labels(1,framesApart+1:end);
 labels = labels/500;
 topLeftPresentTrain.Labels = labels;
 
 %t-1 frame initialisation, very similar to above.
 topLeftPastTrain = imageDatastore(topLevelPath);
 
  for i = 1:1:framesApart
      topLeftPastTrain.Files = setdiff(topLeftPastTrain.Files,topLeftPastTrain.Files{end,1});
 end

 labels = importdata(fullfile(topLevelPath, 'lab_L.mat'));
 labels = labels(1,1:end-framesApart);
 labels = labels/500;
 topLeftPastTrain.Labels = labels;
 
 
 %Initialise validation data datastore as well
  topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Left', ...
  ('exp'+string(r1(1,1))));
 

 topLeftPresentValidate = imageDatastore(topLevelPath);
 
  for i = 1:1:framesApart
       topLeftPresentValidate.Files = setdiff(topLeftPresentValidate.Files,topLeftPresentValidate.Files{1,1});
  end
 

 
 labels = importdata(fullfile(topLevelPath, 'lab_L.mat'));
 labels = labels(1,framesApart+1:end);
 labels = labels/500;
 topLeftPresentValidate.Labels = labels;
 
 topLeftPastValidate = imageDatastore(topLevelPath);
 
   for i = 1:1:framesApart
        topLeftPastValidate.Files = setdiff(topLeftPastValidate.Files,topLeftPastValidate.Files{end,1});
   end

 labels = importdata(fullfile(topLevelPath, 'lab_L.mat'));
 labels = labels(1,1:end-framesApart);
 labels = labels/500;
 topLeftPastValidate.Labels = labels;
 
 indexR1 = 2;
 
 
   for i = 401:732
      
    topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Left', ...
     ('exp'+string(i)));
 
    if (size(r1,2) >= indexR1)
        if r1(1,indexR1) == i
            indexR1 = indexR1 + 1;
        end
    end
    
    if exist((fullfile(topLevelPath, 'lab_L.mat')), 'file')
                   
         labels = importdata(fullfile(topLevelPath, 'lab_L.mat'));
                 
         imdsPresent = imageDatastore(topLevelPath);
         imdsPast = imageDatastore(topLevelPath);
         
        for h = 1:1:framesApart
            imdsPresent.Files = setdiff(imdsPresent.Files,imdsPresent.Files{1,1});
            imdsPast.Files = setdiff(imdsPast.Files,imdsPast.Files{end,1});
        end
        
         imdsPresent.Labels = labels(1,framesApart+1:end)/500;
         imdsPast.Labels = labels(1,1:end-framesApart)/500;
     

         if r1(1,(indexR1-1)) == i

            tmpLabels = topLeftPresentValidate.Labels;
            topLeftPresentValidate = imageDatastore(cat(1,topLeftPresentValidate.Files,imdsPresent.Files));
            topLeftPresentValidate.Labels = cat(1,tmpLabels,imdsPresent.Labels);

            tmpLabels = topLeftPastValidate.Labels;
            topLeftPastValidate = imageDatastore(cat(1,topLeftPastValidate.Files,imdsPast.Files));
            topLeftPastValidate.Labels = cat(1,tmpLabels,imdsPast.Labels);
            
         else
             
            tmpLabels = topLeftPresentTrain.Labels;
            topLeftPresentTrain = imageDatastore(cat(1,topLeftPresentTrain.Files,imdsPresent.Files));
            topLeftPresentTrain.Labels = cat(1,tmpLabels,imdsPresent.Labels);

            tmpLabels = topLeftPastTrain.Labels;
            topLeftPastTrain = imageDatastore(cat(1,topLeftPastTrain.Files,imdsPast.Files));
            topLeftPastTrain.Labels = cat(1,tmpLabels,imdsPast.Labels);
            
         end
                          
    end

   end
   
%CENTER
%First manual initialisation of the datastores

 topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Center', ...
  ('exp'+string(400)));
 
 topCenterPresentTrain = imageDatastore(topLevelPath);
 
   for i = 1:1:framesApart
       topCenterPresentTrain.Files = setdiff(topCenterPresentTrain.Files,topCenterPresentTrain.Files{1,1});
   end
 

 
 labels = importdata(fullfile(topLevelPath, 'lab_C.mat'));
 labels = labels(1,framesApart+1:end);
 labels = labels/500;
 topCenterPresentTrain.Labels = labels;
 
 %t-1 frame initialisation, very similar to above.
 topCenterPastTrain = imageDatastore(topLevelPath);
 
    for i = 1:1:framesApart
        topCenterPastTrain.Files = setdiff(topCenterPastTrain.Files,topCenterPastTrain.Files{end,1});
    end
   
 labels = importdata(fullfile(topLevelPath, 'lab_C.mat'));
 labels = labels(1,1:end-framesApart);
 labels = labels/500;
 topCenterPastTrain.Labels = labels;
 
 
 %Initialise validation data datastore as well
  topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Center', ...
  ('exp'+string(r1(1,1))));
 

 topCenterPresentValidate = imageDatastore(topLevelPath);
 
    for i = 1:1:framesApart
       topCenterPresentValidate.Files = setdiff(topCenterPresentValidate.Files,topCenterPresentValidate.Files{1,1});
    end
   
    
 
 
 labels = importdata(fullfile(topLevelPath, 'lab_C.mat'));
 labels = labels(1,framesApart+1:end);
 labels = labels/500;
 topCenterPresentValidate.Labels = labels;
 
 topCenterPastValidate = imageDatastore(topLevelPath);
 
     for i = 1:1:framesApart
        topCenterPastValidate.Files = setdiff(topCenterPastValidate.Files,topCenterPastValidate.Files{end,1});
     end
    

 labels = importdata(fullfile(topLevelPath, 'lab_C.mat'));
 labels = labels(1,1:end-framesApart);
 labels = labels/500;
 topCenterPastValidate.Labels = labels;
 
 indexR1 = 2;
 
 
   for i = 401:732
      
    topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Center', ...
     ('exp'+string(i)));
 
    if (size(r1,2) >= indexR1)
        if r1(1,indexR1) == i
            indexR1 = indexR1 + 1;
        end
    end

    if exist((fullfile(topLevelPath, 'lab_C.mat')), 'file')
                   
         labels = importdata(fullfile(topLevelPath, 'lab_C.mat'));
                 
         imdsPresent = imageDatastore(topLevelPath);
         imdsPast = imageDatastore(topLevelPath);
         
        for h = 1:1:framesApart
            imdsPresent.Files = setdiff(imdsPresent.Files,imdsPresent.Files{1,1});
            imdsPast.Files = setdiff(imdsPast.Files,imdsPast.Files{end,1});
        end

         
         imdsPresent.Labels = labels(1,framesApart+1:end)/500;
         imdsPast.Labels = labels(1,1:end-framesApart)/500;
     

         if r1(1,(indexR1-1)) == i

            tmpLabels = topCenterPresentValidate.Labels;
            topCenterPresentValidate = imageDatastore(cat(1,topCenterPresentValidate.Files,imdsPresent.Files));
            topCenterPresentValidate.Labels = cat(1,tmpLabels,imdsPresent.Labels);

            tmpLabels = topCenterPastValidate.Labels;
            topCenterPastValidate = imageDatastore(cat(1,topCenterPastValidate.Files,imdsPast.Files));
            topCenterPastValidate.Labels = cat(1,tmpLabels,imdsPast.Labels);
            
         else
             
            tmpLabels = topCenterPresentTrain.Labels;
            topCenterPresentTrain = imageDatastore(cat(1,topCenterPresentTrain.Files,imdsPresent.Files));
            topCenterPresentTrain.Labels = cat(1,tmpLabels,imdsPresent.Labels);

            tmpLabels = topCenterPastTrain.Labels;
            topCenterPastTrain = imageDatastore(cat(1,topCenterPastTrain.Files,imdsPast.Files));
            topCenterPastTrain.Labels = cat(1,tmpLabels,imdsPast.Labels);
            
         end
                          
    end

   end
   
%RIGHT
%First manual initialisation of the datastores

 topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Right', ...
  ('exp'+string(400)));
 
 topRightPresentTrain = imageDatastore(topLevelPath);
 
  for i = 1:1:framesApart
     topRightPresentTrain.Files = setdiff(topRightPresentTrain.Files,topRightPresentTrain.Files{1,1});
  end
    
 
 labels = importdata(fullfile(topLevelPath, 'lab_R.mat'));
 labels = labels(1,framesApart+1:end);
 labels = labels/500;
 topRightPresentTrain.Labels = labels;
 
 %t-1 frame initialisation, very similar to above.
 topRightPastTrain = imageDatastore(topLevelPath);
 
   for i = 1:1:framesApart
     topRightPastTrain.Files = setdiff(topRightPastTrain.Files,topRightPastTrain.Files{end,1});
   end
      
 

 labels = importdata(fullfile(topLevelPath, 'lab_R.mat'));
 labels = labels(1,1:end-framesApart);
 labels = labels/500;
 topRightPastTrain.Labels = labels;
 
 
 %Initialise validation data datastore as well
  topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Right', ...
  ('exp'+string(r1(1,1))));
 

 topRightPresentValidate = imageDatastore(topLevelPath);
 
    for i = 1:1:framesApart
     topRightPresentValidate.Files = setdiff(topRightPresentValidate.Files,topRightPresentValidate.Files{1,1});
    end
   
    
 
 
 labels = importdata(fullfile(topLevelPath, 'lab_R.mat'));
 labels = labels(1,framesApart+1:end);
 labels = labels/500;
 topRightPresentValidate.Labels = labels;
 
 topRightPastValidate = imageDatastore(topLevelPath);
 
     for i = 1:1:framesApart
      topRightPastValidate.Files = setdiff(topRightPastValidate.Files,topRightPastValidate.Files{end,1});
     end
    
     


 labels = importdata(fullfile(topLevelPath, 'lab_R.mat'));
 labels = labels(1,1:end-framesApart);
 labels = labels/500;
 topRightPastValidate.Labels = labels;
 
 indexR1 = 2;
 
 
   for i = 401:732
      
    topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor_Right', ...
     ('exp'+string(i)));
 
    if (size(r1,2) >= indexR1)
        if r1(1,indexR1) == i
            indexR1 = indexR1 + 1;
        end
    end

    if exist((fullfile(topLevelPath, 'lab_R.mat')), 'file')
                   
         labels = importdata(fullfile(topLevelPath, 'lab_R.mat'));
                 
         imdsPresent = imageDatastore(topLevelPath);
         imdsPast = imageDatastore(topLevelPath);
         
        for h = 1:1:framesApart
            imdsPresent.Files = setdiff(imdsPresent.Files,imdsPresent.Files{1,1});
            imdsPast.Files = setdiff(imdsPast.Files,imdsPast.Files{end,1});
        end

         
         imdsPresent.Labels = labels(1,framesApart+1:end)/500;
         imdsPast.Labels = labels(1,1:end-framesApart)/500;
     

         if r1(1,(indexR1-1)) == i

            tmpLabels = topRightPresentValidate.Labels;
            topRightPresentValidate = imageDatastore(cat(1,topRightPresentValidate.Files,imdsPresent.Files));
            topRightPresentValidate.Labels = cat(1,tmpLabels,imdsPresent.Labels);

            tmpLabels = topRightPastValidate.Labels;
            topRightPastValidate = imageDatastore(cat(1,topRightPastValidate.Files,imdsPast.Files));
            topRightPastValidate.Labels = cat(1,tmpLabels,imdsPast.Labels);
            
         else
             
            tmpLabels = topRightPresentTrain.Labels;
            topRightPresentTrain = imageDatastore(cat(1,topRightPresentTrain.Files,imdsPresent.Files));
            topRightPresentTrain.Labels = cat(1,tmpLabels,imdsPresent.Labels);

            tmpLabels = topRightPastTrain.Labels;
            topRightPastTrain = imageDatastore(cat(1,topRightPastTrain.Files,imdsPast.Files));
            topRightPastTrain.Labels = cat(1,tmpLabels,imdsPast.Labels);
            
         end
                          
    end

   end
  
   topPresentTrain = imageDatastore(cat(1,topLeftPresentTrain.Files,topCenterPresentTrain.Files, topRightPresentTrain.Files));
   topPresentTrain.Labels = cat(1,topLeftPresentTrain.Labels, topCenterPresentTrain.Labels, topRightPresentTrain.Labels);
   
   topPastTrain = imageDatastore(cat(1,topLeftPastTrain.Files,topCenterPastTrain.Files, topRightPastTrain.Files));
   topPastTrain.Labels = cat(1,topLeftPastTrain.Labels, topCenterPastTrain.Labels, topRightPastTrain.Labels);
   
   topPresentValidate = imageDatastore(cat(1,topLeftPresentValidate.Files,topCenterPresentValidate.Files, topRightPresentValidate.Files));
   topPresentValidate.Labels = cat(1,topLeftPresentValidate.Labels, topCenterPresentValidate.Labels, topRightPresentValidate.Labels);
   
   
   topPastValidate = imageDatastore(cat(1,topLeftPastValidate.Files,topCenterPastValidate.Files, topRightPastValidate.Files));
   topPastValidate.Labels = cat(1,topLeftPastValidate.Labels, topCenterPastValidate.Labels, topRightPastValidate.Labels);
   
   
   
   imdsTwoFrameTraining = combine(topPresentTrain, topPastTrain);
   imdsTwoFrameValidate = combine(topPresentValidate, topPastValidate);