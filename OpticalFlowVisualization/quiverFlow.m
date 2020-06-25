%test = read(trainingSetOpti);
% img = test{1,1}(:,:,1:3);
% img = uint8(img);

% optiFlow = test{1,1}(:,:,4:5);
% 
% X = optiFlow(:,:,1);
% Y = optiFlow(:,:,2);

h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);

% opflow = opticalFlow(optiFlow(:,:,1),optiFlow(:,:,2));
 opflow = opticalFlow(X,Y);

    imshow(img)
    hold on
    plot(opflow,'DecimationFactor',[5 5],'ScaleFactor',5,'Parent',hPlot);
    hold off