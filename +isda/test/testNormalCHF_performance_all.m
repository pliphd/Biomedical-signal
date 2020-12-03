% test performance
clc; close all; clear;

%% config
load testNormalCHF_partial.mat

workInterval = 100:-5:5;
workRadius   = 100:-5:5;

%% average
pDistEn1 = reshape(pDistEn_CHF, size(pDistEn_CHF, 1)*size(pDistEn_CHF, 2), length(workInterval), length(workRadius));
pDistEn0 = reshape(pDistEn_NSR, size(pDistEn_NSR, 1)*size(pDistEn_NSR, 2), length(workInterval), length(workRadius));

groups   = [repmat({'chf'}, size(pDistEn1, 1), 1); repmat({'nsr'}, size(pDistEn0, 1), 1)];

for iI = 1:length(workInterval)
    for iR = 1:length(workRadius)
        pDistEn_chf = pDistEn1(:, iI, iR);
        pDistEn_nsr = pDistEn0(:, iI, iR);
        
        x = [pDistEn_chf; pDistEn_nsr];
        
        XY = table(x, groups);
        XY(isnan(x), :) = [];
        
        %% 10-fold cv
        
        X = XY.x;
        Y = XY.groups;
            order = unique(Y);             % Order of the group labels
            cp    = cvpartition(Y,'k',3); % Stratified cross-validation
            
            f = @(xtr,ytr,xte,yte)confusionmat(yte,...
                classify(xte,xtr,ytr), 'order', order);
            
            cfMat = crossval(f, X, Y, 'partition', cp);
            cfMat = reshape(sum(cfMat), 2, 2);
            disp(['workInterval: ' num2str(workInterval(iI))]);
            disp(['workRadius: ' num2str(workRadius(iR))]);
            disp('Confusion matrix:');
            disp(cfMat);
            
            sen = cfMat(1, 1)/(cfMat(1, 1) + cfMat(1, 2));
            spe = cfMat(2, 2)/(cfMat(2, 1) + cfMat(2, 2));
            
            disp(['sensivitiy: ' sprintf('%.4f', sen)]);
            disp(['specificity: ' sprintf('%.4f', spe)]);
    end
end