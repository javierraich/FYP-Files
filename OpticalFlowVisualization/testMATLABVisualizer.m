%Recall function is at C:\Users\Javier R\Downloads\correspondenceVisualization\matlab\hci

% X = test{1,1}(:,:,4);
% Y = test{1,1}(:,:,5);

addpath 'C:\Users\Javier R\Downloads\correspondenceVisualization\matlab\hci'

[ rgbImageAll ] = flow_visualization( X*3, Y*3 );

figure
image( rgbImageAll ); 
axis image;