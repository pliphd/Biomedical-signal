% plot NormalCHF partial DistEn differentiation

clc; close all; clear;

%% config
load testNormalCHF_partial.mat

len = 5;         % in min;
starttime = datetime('20:00:00', 'InputFormat', 'HH:mm:ss'):minutes(len):datetime('20:00:00', 'InputFormat', 'HH:mm:ss')+hours(8);
starttime(end) = [];

workInterval = 100:-5:5;
workRadius   = 100:-5:5;

savept = './testNormalCHF';
if ~(exist(savept, 'dir') == 7)
    mkdir(savept);
end

%% plot
for iS = 1:length(starttime)
    pDistEn_nsr = squeeze(pDistEn_NSR(iS, :, :, :));
    pDistEn_chf = squeeze(pDistEn_CHF(iS, :, :, :));
    
    pDistEn_nsr_m = squeeze(mean(pDistEn_nsr, 1));
    pDistEn_nsr_s = squeeze(std(pDistEn_nsr, [], 1));
    
    pDistEn_chf_m = squeeze(mean(pDistEn_chf, 1));
    pDistEn_chf_s = squeeze(std(pDistEn_chf, [], 1));
    
    d = (pDistEn_nsr_m - pDistEn_chf_m) ./ sqrt(pDistEn_nsr_s.*2 + pDistEn_chf_s.*2);
    
    [WorkInterval, WorkRadius] = meshgrid(workInterval, workRadius);
    
    Pos = CenterFig(8, 6, 'centimeter');
    figure('Color', 'w', 'Units', 'centimeter', 'Position', Pos);
    
    contourf(WorkInterval, WorkRadius, d);
    colorbar;
    xlabel('Work interval \it{k}');
    ylabel('Work radius \it{\delta}');
    
    title(datestr(starttime(iS), 'HH:MM:ss'), 'Interpreter', 'none');
    
    print(fullfile(savept, [datestr(starttime(iS), 'HHMMss') '.jpg']), '-djpeg', '-r300');
    close;
end