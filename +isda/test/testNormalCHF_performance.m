% test performance
clc; close all; clear;

%% config
load testNormalCHF_partial.mat

workInterval = 100:-5:5;
workRadius   = 100:-5:5;

%% average
pDistEn1 = squeeze(nanmean(pDistEn_CHF, 1));
pDistEn0 = squeeze(nanmean(pDistEn_NSR, 1));

groups   = [repmat({'chf'}, size(pDistEn1, 1), 1); repmat({'nrm'}, size(pDistEn0, 1), 1)];

for iI = 1:length(workInterval)
    for iR = 1:length(workRadius)
        pDistEn_chf = pDistEn1(:, iI, iR);
        pDistEn_nrm = pDistEn0(:, iI, iR);
        
        x = [pDistEn_chf; pDistEn_nrm];
        
        %% 10-fold cv

            order = unique(groups);             % Order of the group labels
            cp    = cvpartition(groups,'k',10); % Stratified cross-validation
            
            f = @(xtr,ytr,xte,yte)confusionmat(yte,...
                classify(xte,xtr,ytr), 'order', order);
            
            cfMat = crossval(f, x, groups, 'partition', cp);
            cfMat = reshape(sum(cfMat), 2, 2);
            disp(['workInterval: ' num2str(workInterval(iI))]);
            disp(['workRadius: ' num2str(workRadius(iR))]);
            disp('Confusion matrix:');
            disp(cfMat);

    end
end