% test
clear; close all; clc;

if exist('testData.mat', 'file') == 2
    load testData;
    
    workInterval = 100:-5:5;
    workRadius   = 100:-5:5;
else
    %% para
    dataPt  = 'C:\Users\pliph\Projects\2_Complete_Projects\201701 ExerciseRestHRV\Data';
    
    %% resting
    allFile = dir(fullfile(dataPt, '*J.txt'));
    
    cDistEn = nan(length(allFile), 1);
    obj     = isda.isda;
    obj.EmbedDimension   = 3;
    obj.TimeDelay        = 1;
    obj.WorkInterval     = 10000;
    obj.WorkRadius       = 10000;
    obj.Normalization    = 'minmax';
    obj.DistanceFunction = 'chebychev';
    for iF  = 1:length(allFile)
        obj.Data = load(fullfile(dataPt, allFile(iF).name));
        cDistEn(iF) = obj.partialDistEn('BinNumber', 256);
    end
    
    workInterval = 100:-5:5;
    workRadius   = 100:-5:5;
    pDistEn      = nan(length(workInterval), length(workRadius), length(allFile));
    for iF       = 1:length(allFile)
        obj.Data = load(fullfile(dataPt, allFile(iF).name));
        for iI   = 1:length(workInterval)
            obj.WorkInterval = workInterval(iI);
            for iR = 1:length(workRadius)
                obj.WorkRadius = workRadius(iR);
                if length(obj.InterStateDistance) >= 64*8
                    binNumber = 64;
                elseif length(obj.InterStateDistance) >= 32*8
                    binNumber = 32;
                elseif length(obj.InterStateDistance) >= 16*8
                    binNumber = 16;
                else
                    binNumber = 8;
                end
                pDistEn(iI, iR, iF) = obj.partialDistEn('BinNumber', binNumber);
            end
        end
    end
    
    restCDistEn = cDistEn;
    restPDistEn = pDistEn;
    
    %% walking
    allFile = dir(fullfile(dataPt, '*Y.txt'));
    
    cDistEn = nan(length(allFile), 1);
    obj     = isda.isda;
    obj.EmbedDimension   = 3;
    obj.TimeDelay        = 1;
    obj.WorkInterval     = 10000;
    obj.WorkRadius       = 10000;
    obj.Normalization    = 'minmax';
    obj.DistanceFunction = 'chebychev';
    for iF  = 1:length(allFile)
        obj.Data = load(fullfile(dataPt, allFile(iF).name));
        cDistEn(iF) = obj.partialDistEn('BinNumber', 256);
    end
    
    workInterval = 100:-5:5;
    workRadius   = 100:-5:5;
    pDistEn      = nan(length(workInterval), length(workRadius), length(allFile));
    for iF       = 1:length(allFile)
        obj.Data = load(fullfile(dataPt, allFile(iF).name));
        for iI   = 1:length(workInterval)
            obj.WorkInterval = workInterval(iI);
            for iR = 1:length(workRadius)
                obj.WorkRadius = workRadius(iR);
                if length(obj.InterStateDistance) >= 64*8
                    binNumber = 64;
                elseif length(obj.InterStateDistance) >= 32*8
                    binNumber = 32;
                elseif length(obj.InterStateDistance) >= 16*8
                    binNumber = 16;
                else
                    binNumber = 8;
                end
                pDistEn(iI, iR, iF) = obj.partialDistEn('BinNumber', binNumber);
            end
        end
    end
    
    walkCDistEn = cDistEn;
    walkPDistEn = pDistEn;
end

%% output
mpRest = mean(restPDistEn, 3);
spRest = std(restPDistEn, [], 3);
mpWalk = mean(walkPDistEn, 3);
spWalk = std(walkPDistEn, [], 3);

mcRest = mean(restCDistEn);
scRest = std(restCDistEn);
mcWalk = mean(walkCDistEn);
scWalk = std(walkCDistEn);

leftP  = linspace(.06, .94, length(workInterval));
botP   = linspace(.94, .06, length(workRadius));

wid    = .03; hei = .03;

% Pos = CenterFig(20, 20, 'centimeter');
% hf  = figure('Color', 'w', 'Units', 'centimeters', 'Position', Pos);
% 
% for iL = 1:length(leftP)
%     for iB = 1:length(botP)
%         ha = axes(hf, 'Units', 'normalized', 'Position', [leftP(iL) botP(iB) wid hei], 'NextPlot', 'add');
%         errorbar(ha, 1, mpRest(iL, iB), spRest(iL, iB), 'Marker', 'o', 'MarkerSize', 2, 'Color', 'k');
%         errorbar(ha, 2, mpWalk(iL, iB), spWalk(iL, iB), 'Marker', '^', 'MarkerSize', 2, 'Color', 'k');
%         
%         ha.XLim = [.5 2.5]; ha.XTick = [1 2];
%         ha.YLim = [0.5 1];  ha.YTick = [];
%         
%         if iB ~= length(botP)
%             ha.XColor = 'none';
%         end
%         if iL ~= 1
%             ha.YColor = 'none';
%         end
%         
%         ha.Box = 'off';
%     end
% end

%% cohen's d
d = (mpRest - mpWalk) ./ sqrt(spRest.*2 + spWalk.*2);

[WorkInterval, WorkRadius] = meshgrid(workInterval, workRadius);

Pos = CenterFig(8, 6, 'centimeter');
figure('Color', 'w', 'Units', 'centimeter', 'Position', Pos);

contourf(WorkInterval, WorkRadius, d);
colorbar;
xlabel('????\it{k}');
ylabel('????\it{\delta}');
