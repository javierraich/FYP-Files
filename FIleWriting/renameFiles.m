topLevelPath = fullfile('c:\','Users','Javier R','Downloads', '3_Corridor');

cd (topLevelPath)
directories = dir();

numFolds = size(directories);
numFolds = numFolds(1);

for i = 3:numFolds
   cd  (fullfile (topLevelPath, directories(i,1).name))
   images = dir();
   
   numFiles= size(images);
   numFiles = numFiles(1);
   
   matches = regexp( images(3,1).name, '(.+)\d+.jpg$', 'tokens' );
   rootName = char(matches{1,1});
   

   for j = 3:numFiles
    str = images(j,1).name;

    matches = regexp( images(j,1).name, '(\d+).jpg$', 'tokens' );
    
    if (not(isempty(matches)))
        extractednum = str2double(char(matches{1,1}));
    
        newName =  strcat(rootName,num2str(extractednum, '%03.f'),'.jpg');
        
        if(not(strcmp(newName,images(j,1).name)))
            movefile(images(j,1).name, newName);
        end
    end
       
   end
   
end