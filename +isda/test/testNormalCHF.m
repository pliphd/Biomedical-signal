% test
clear; close all; clc;

if exist('testNormalCHF.mat', 'file') == 2
    load testNormalCHF;
    nsrpath = 'C:\Users\pliph\Data\NN intervals\MIT-BIH NSR NN intervals with starting time\NN intervals';
    chfpath = 'C:\Users\pliph\Data\NN intervals\BIDMC CHF NN intervals with starting time\NN intervals';
else
    
    %% config
    % NN data path
    nsrpath = 'C:\Users\pliph\Data\NN intervals\MIT-BIH NSR NN intervals with starting time\NN intervals';
    chfpath = 'C:\Users\pliph\Data\NN intervals\BIDMC CHF NN intervals with starting time\NN intervals';
    
    len = 5; % in min;
    nn_length = minutes(len);
    
    starttime = datetime('20:00:00', 'InputFormat', 'HH:mm:ss'):minutes(len):datetime('20:00:00', 'InputFormat', 'HH:mm:ss')+hours(8);
    starttime(end) = [];
    
    %% batch
    % nsr
    allfile = dir(fullfile(nsrpath, '1*.txt'));
    
    cDistEn = nan(length(allfile), 1);
    pDistEn = nan(length(allfile), 1);
    
    obj     = isda.isda;
    obj.EmbedDimension   = 3;
    obj.TimeDelay        = 1;
    obj.Normalization    = 'minmax';
    obj.DistanceFunction = 'chebychev';
    
    for ia  = 1:length(allfile)
        curfile = allfile(ia).name;
        
        nn_orig = readtable(fullfile(nsrpath, curfile), 'ReadVariableNames', 0, 'Delimiter', '\t', 'DatetimeType', 'datetime', 'Format', '%.6f\t%{yyyy/MM/dd HH:mm:ss.SSS}D');
        pts = physiologicaltimeseries(nn_orig.(1), datenum(nn_orig.(2)));
        
        iS = 1;
        curstarttime1 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate)),   'ConvertFrom', 'datenum');
        curstarttime2 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate))+1, 'ConvertFrom', 'datenum');
        
        spts1 = getinterestedsample(pts, curstarttime1, nn_length);
        spts2 = getinterestedsample(pts, curstarttime2, nn_length);
        
        if ~isempty(spts1.Data)
            nn = spts1.Data;
            nt = spts1.Time;
            st = curstarttime1;
        else
            nn = spts2.Data;
            nt = spts2.Time;
            st = curstarttime2;
        end
        
        obj.Data = nn;
        
        obj.WorkInterval = 10000;
        obj.WorkRadius   = 10000;
        cDistEn(ia)      = obj.partialDistEn('BinNumber', 256);
        
        obj.WorkInterval = 10;
        obj.WorkRadius   = 10;
        pDistEn(ia)      = obj.partialDistEn('BinNumber', 256);
    end
    
    %%
    % chf
    allfile = dir(fullfile(chfpath, 'chf*.txt'));
    
    cDistEn1 = nan(length(allfile), 1);
    pDistEn1 = nan(length(allfile), 1);
    
    obj     = isda.isda;
    obj.EmbedDimension   = 3;
    obj.TimeDelay        = 1;
    obj.Normalization    = 'minmax';
    obj.DistanceFunction = 'chebychev';
    
    for ia  = 1:length(allfile)
        curfile = allfile(ia).name;
        
        nn_orig = readtable(fullfile(chfpath, curfile), 'ReadVariableNames', 0, 'Delimiter', '\t', 'DatetimeType', 'datetime', 'Format', '%.6f\t%{yyyy/MM/dd HH:mm:ss.SSS}D');
        pts = physiologicaltimeseries(nn_orig.(1), datenum(nn_orig.(2)));
        
        iS = 1;
        curstarttime1 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate)),   'ConvertFrom', 'datenum');
        curstarttime2 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate))+1, 'ConvertFrom', 'datenum');
        
        spts1 = getinterestedsample(pts, curstarttime1, nn_length);
        spts2 = getinterestedsample(pts, curstarttime2, nn_length);
        
        if ~isempty(spts1.Data)
            nn = double(spts1.Data);
            nt = spts1.Time;
            st = curstarttime1;
        else
            nn = double(spts2.Data);
            nt = spts2.Time;
            st = curstarttime2;
        end
        
        obj.Data = nn;
        
        obj.WorkInterval = 10000;
        obj.WorkRadius   = 10000;
        cDistEn1(ia)      = obj.partialDistEn('BinNumber', 256);
        
        obj.WorkInterval = 10;
        obj.WorkRadius   = 10;
        pDistEn1(ia)      = obj.partialDistEn('BinNumber', 256);
    end
    save testNormalCHF.mat cDistEn cDistEn1 pDistEn pDistEn1
end

% %% plot
% Pos = CenterFig(10, 6, 'centimeter');
% figure('Color', 'w', 'Units', 'centimeter', 'Position', Pos);
% subplot(121); hold on;
% bar([1 2], [mean(pDistEn) mean(pDistEn1)], 'FaceColor', [.5 .5 .5], 'EdgeColor', 'k');
% errorbar([1 2], [mean(pDistEn) mean(pDistEn1)], [0 0], [std(pDistEn) std(pDistEn1)], 'k', 'LineStyle', 'none');
% 
% subplot(122); hold on;
% bar([1 2], [mean(cDistEn) mean(cDistEn1)], 'FaceColor', [.5 .5 .5], 'EdgeColor', 'k');
% errorbar([1 2], [mean(cDistEn) mean(cDistEn1)], [0 0], [std(cDistEn) std(cDistEn1)], 'k', 'LineStyle', 'none');

%% plot
Pos = CenterFig(10, 6, 'centimeter');
figure('Color', 'w', 'Units', 'centimeter', 'Position', Pos);
hold on;
bar([1 2], [mean(pDistEn) mean(pDistEn1)], 'FaceColor', [.5 .5 .5], 'EdgeColor', 'k', 'BarWidth', .6);
errorbar([1 2], [mean(pDistEn) mean(pDistEn1)], [0 0], ...
    [std(pDistEn) std(pDistEn1)]./sqrt([length(dir(fullfile(nsrpath, '1*.txt'))) length(dir(fullfile(chfpath, 'chf*.txt')))]), ...
    'k', 'LineStyle', 'none', ...
    'CapSize', 20);
set(gca, 'XLim', [.5 2.5], 'XTick', [1 2], 'XTickLabel', {'???', '???'}, ...
    'YLim', [.3 .6], 'YTick', .3:.1:.6);
set(gca, 'TickLength', [.025 .025], 'TickDir', 'out');
xlabel('??');
ylabel('???');