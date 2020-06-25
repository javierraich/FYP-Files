maxOptiCumm = 0;

while validationSetOpti.hasdata
    tst = trainingSetOpti.read;
    maxOpti = max(abs(tst{1,1}(:,:,4:5)),[],'all');
    maxOptiCumm = max([maxOpti, maxOptiCumm]);
end