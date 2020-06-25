roundedTrue = round(trueDistances, 3); 

bins = 0:0.002:max(roundedTrue);
 
binStd = zeros(numel(bins),1);
binMean = zeros(numel(bins),1);
binNumel = zeros(numel(bins),1);

for j = 1:numel(bins)
    binCumm = 0;
    counter = 0;
    
    for i = 1:numValidation
       if roundedTrue(i,1) == bins(1,j)
           binCumm(counter+1,1) = predictedDistances(i,1);
           counter = counter +  1;
       end

    end
    
    binStd(j,1) = std(binCumm);
    binMean(j,1) = mean(binCumm);
    binNumel(j,1) = counter;
end

counter  = 0;

upperBound = 0;
lowerBound = 0;
axisVal = 0;
meanVal = 0;

for i = 1:numel(bins)

    numEls = binNumel(i,1);
    
    if numEls > 20
        
       counter = counter + 1;
       
       meanBin = binMean(i,1);
       
       ySEM = binStd(139,1)/sqrt(numEls);                              % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
       CI95 = tinv([0.025 0.975], numEls-1);                    % Calculate 95% Probability Intervals Of t-Distribution

       bounds  = (CI95 * ySEM) + meanBin;                       % Calculate 95% Confidence Intervals
       
       lowerBound(counter,1) = bounds(1,1);
       upperBound(counter,1) = bounds(1,2);
       axisVal(counter,1) = bins(1,i);
       meanVal(counter,1) = meanBin;
       
       
    end
end

scaleFactor = 500;
lowerBound = lowerBound * scaleFactor;
upperBound = upperBound * scaleFactor;
axisVal = axisVal * scaleFactor;
meanVal = meanVal * scaleFactor;

idealX = 0:0.1:max(axisVal)+0.1;
idealY = idealX;

figure
hold on
ciplot(lowerBound, upperBound, axisVal);
plot(axisVal, meanVal, 'color', 'cy');
plot(idealX, idealY, 'color', 'red');
xlabel('Sensor Distance')
ylabel('Predicted Distance')
hold off
