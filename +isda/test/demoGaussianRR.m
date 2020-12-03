% test
clear; close all; clc;

%% container
P  = CenterFig(18, 10, 'centimeters');
hf = figure('Color', 'w', 'Units', 'centimeters', 'Position', P);

%% test1
N = 1000;
sig1 = isda.isda(randn(N, 1), 'EmbedDimension', 3, 'TimeDelay', 1, ...
    'Normalization', 'minmax', 'DistanceFunction', 'chebychev');

ha1  = axes(hf, 'Units', 'normalized', 'Position', [.04 .9 .16 .08]);
plot(ha1, sig1.Data, 'k');
set(ha1, 'XLim', [0 N], 'XTick', 0:500:N, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.04 .56 .06 .28]);
plot(ha2, sig1.StateSpace(1:10, :)'+(0:9), 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.14 .56 .06 .28]);
plot(ha2, sig1.StateSpace(11:20, :)'+(0:9), 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.26 .56 .22 .39]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
text(.3, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/20, 'complete');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .56 .22 .39]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
text(.1, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/20, 'partial: \it{k}\rm=500, \it{\delta}\rm=10');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .56 .22 .39]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
text(.1, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/20, 'partial: \it{k}\rm=10, \it{\delta}\rm=10');

%% test2
N = 1000;
nsrpath = 'C:\Users\pliph\Data\NN intervals\MIT-BIH NSR NN intervals with starting time\NN intervals';
allfile = dir(fullfile(nsrpath, '1*.txt'));
ia = 3;
curfile = allfile(ia).name;
nn_orig = readtable(fullfile(nsrpath, curfile), 'ReadVariableNames', 0, 'Delimiter', '\t', 'DatetimeType', 'datetime', 'Format', '%.6f\t%{yyyy/MM/dd HH:mm:ss.SSS}D');
pts = physiologicaltimeseries(nn_orig.(1), datenum(nn_orig.(2)));

starttime = datetime('00:00:00', 'InputFormat', 'HH:mm:ss'):minutes(10):datetime('00:00:00', 'InputFormat', 'HH:mm:ss')+hours(24);
starttime(end) = []; iS = 55;
curstarttime1 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate)),   'ConvertFrom', 'datenum');
curstarttime2 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate))+1, 'ConvertFrom', 'datenum');

spts1 = getinterestedsample(pts, curstarttime1, N);
spts2 = getinterestedsample(pts, curstarttime2, N);

if ~isempty(spts1.Data)
    nn = spts1.Data;
    nt = spts1.Time;
    st = curstarttime1;
else
    nn = spts2.Data;
    nt = spts2.Time;
    st = curstarttime2;
end

sig1 = isda.isda(nn, 'EmbedDimension', 3, 'TimeDelay', 1, ...
    'Normalization', 'minmax', 'DistanceFunction', 'chebychev');

ha1  = axes(hf, 'Units', 'normalized', 'Position', [.04 .9-.5 .16 .08]);
plot(ha1, sig1.Data, 'k');
set(ha1, 'XLim', [0 N], 'XTick', 0:500:N, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.04 .56-.5 .06 .28]);
plot(ha2, sig1.StateSpace(1:10, :)'+(0:9), 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.14 .56-.5 .06 .28]);
plot(ha2, sig1.StateSpace(11:20, :)'+(0:9), 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.26 .56-.5 .22 .39]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
text(.3, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/20, 'complete');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .56-.5 .22 .39]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
text(.1, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/20, 'partial: \it{k}\rm=500, \it{\delta}\rm=10');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .56-.5 .22 .39]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
text(.1, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/20, 'partial: \it{k}\rm=10, \it{\delta}\rm=10');

%% legend
hab  = axes(hf, 'Units', 'normalized', 'Position', [0 0 1 1], 'Layer', 'bottom', ...
    'XColor', 'none', 'YColor', 'none', 'Color', 'none');
hab.XLim = [0 1]; hab.YLim = [0 1];
text(.002, .98, '(A1)', 'FontWeight', 'bold', 'FontSize', 8);
text(.002, .84, '(B1)', 'FontWeight', 'bold', 'FontSize', 8);
text(.24, .98, '(C1)', 'FontWeight', 'bold', 'FontSize', 8);

text(.002, .98-.5, '(A2)', 'FontWeight', 'bold', 'FontSize', 8);
text(.002, .84-.5, '(B2)', 'FontWeight', 'bold', 'FontSize', 8);
text(.24, .98-.5, '(C2)', 'FontWeight', 'bold', 'FontSize', 8);