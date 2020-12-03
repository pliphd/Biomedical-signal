% test
clear; close all; clc;

%% container
P  = CenterFig(18, 16, 'centimeters');
hf = figure('Color', 'w', 'Units', 'centimeters', 'Position', P);

%% test1
N = 1000;
sig1 = isda.isda(randn(N, 1), 'EmbedDimension', 3, 'TimeDelay', 1, ...
    'Normalization', 'minmax', 'DistanceFunction', 'chebychev');

ha1  = axes(hf, 'Units', 'normalized', 'Position', [.04 .95 .16 .04]);
plot(ha1, sig1.Data, 'k');
set(ha1, 'XLim', [0 N], 'XTick', 0:500:N, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.04 .72 .06 .16]);
plot(ha2, sig1.StateSpace(1:10, :)'+(0:9), 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.14 .72 .06 .16]);
plot(ha2, sig1.StateSpace(11:20, :)'+(0:9), 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.28 .87 .22 .1]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(150, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'complete');
xlabel('\it{i}');
ylabel('\it{j}');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.26 .72 .22 .1]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');


ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .87 .22 .1]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(-200, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'partial: \it{k}\rm=500, \it{\delta}\rm=10');
xlabel('\it{i}');
ylabel('\it{j}');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .72 .22 .1]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');


ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .87 .22 .1]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(-200, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'partial: \it{k}\rm=10, \it{\delta}\rm=10');
xlabel('\it{i}');
ylabel('\it{j}');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .72 .22 .1]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');

%% test2
N = 1000;
sig1 = isda.isda(mlr(0, 4, .1, N), 'EmbedDimension', 3, 'TimeDelay', 1, ...
    'Normalization', 'minmax', 'DistanceFunction', 'chebychev');

hab  = axes(hf, 'Units', 'normalized', 'Position', [0, .31+.02, 1, .41-.075], 'Color', [.8 .8 .9]);
set(hab, 'XColor', 'none', 'YColor', 'none');

ha1  = axes(hf, 'Units', 'normalized', 'Position', [.04 .95-.33 .16 .04]);
plot(ha1, sig1.Data, 'k');
set(ha1, 'XLim', [0 N], 'XTick', 0:500:N, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');
set(ha1, 'Color', 'none');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.04 .72-.33 .06 .16]);
plot(ha2, sig1.StateSpace(1:10, :)'+(0:9)*2, 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');
set(ha2, 'Color', 'none');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.14 .72-.33 .06 .16]);
plot(ha2, sig1.StateSpace(11:20, :)'+(0:9)*2, 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');
set(ha2, 'Color', 'none');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.28 .87-.33 .22 .1]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(150, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'complete');
xlabel('\it{i}');
ylabel('\it{j}');
set(ha3, 'Color', 'none');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.26 .72-.33 .22 .1]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');
set(ha3, 'Color', 'none');


ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .87-.33 .22 .1]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(-200, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'partial: \it{k}\rm=500, \it{\delta}\rm=10');
xlabel('\it{i}');
ylabel('\it{j}');
set(ha3, 'Color', 'none');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .72-.33 .22 .1]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');
set(ha3, 'Color', 'none');


ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .87-.33 .22 .1]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(-200, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'partial: \it{k}\rm=10, \it{\delta}\rm=10');
xlabel('\it{i}');
ylabel('\it{j}');
set(ha3, 'Color', 'none');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .72-.33 .22 .1]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');
set(ha3, 'Color', 'none');

%% test3
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

ha1  = axes(hf, 'Units', 'normalized', 'Position', [.04 .95-.66 .16 .04]);
plot(ha1, sig1.Data, 'k');
set(ha1, 'XLim', [0 N], 'XTick', 0:500:N, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out');

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.04 .72-.66 .06 .16]);
seg  = sig1.StateSpace(1:10, :)'+(0:9)*.3;
plot(ha2, seg, 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out', 'YLim', [min(seg(:))-.1 max(seg(:))]);

ha2  = axes(hf, 'Units', 'normalized', 'Position', [.14 .72-.66 .06 .16]);
seg  = sig1.StateSpace(11:20, :)'+(0:9)*.3;
plot(ha2, seg, 'Marker', '.', 'MarkerSize', 10, 'Color', 'k');
set(ha2, 'XTickLabel', {'\it{x}\rm_{\it{i}}' '\it{x}\rm_{\it{i+1}}' '\it{x}\rm_{\it{i+2}}'}, ...
    'YColor', 'none', 'Box', 'off', ...
    'TickLength', [.03 .03], 'TickDir', 'out', 'YLim', [min(seg(:))-.1 max(seg(:))]);

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.28 .87-.66 .22 .1]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(150, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'complete');
xlabel('\it{i}');
ylabel('\it{j}');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.26 .72-.66 .22 .1]);
sig1.WorkInterval = N; sig1.WorkRadius = N;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');


ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .87-.66 .22 .1]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(-200, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'partial: \it{k}\rm=500, \it{\delta}\rm=10');
xlabel('\it{i}');
ylabel('\it{j}');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.5 .72-.66 .22 .1]);
sig1.WorkInterval = 500; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');


ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .87-.66 .22 .1]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotDist(ha3);
set(ha3, 'Box', 'on', 'TickLength', [.025 .025], 'TickDir', 'out');
% text(-200, ha3.YLim(2)+(ha3.YLim(2)-ha3.YLim(1))/5, 'partial: \it{k}\rm=10, \it{\delta}\rm=10');
xlabel('\it{i}');
ylabel('\it{j}');

ha3  = axes(hf, 'Units', 'normalized', 'Position', [.74 .72-.66 .22 .1]);
sig1.WorkInterval = 10; sig1.WorkRadius = 10;
sig1.plotPdf(ha3, 'pdfMethod', 'histogram', 'binNumber', 32);
set(ha3, 'YColor', 'none', 'Box', 'off', 'TickLength', [.025 .025], 'TickDir', 'out');
ha3.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');

%% legend
hab  = axes(hf, 'Units', 'normalized', 'Position', [0 0 1 1], 'Layer', 'bottom', ...
    'XColor', 'none', 'YColor', 'none', 'Color', 'none');
hab.XLim = [0 1]; hab.YLim = [0 1];
text(.002, .98, '(A1)', 'FontWeight', 'bold', 'FontSize', 8);
text(.002, .9,  '(A2)', 'FontWeight', 'bold', 'FontSize', 8);
text(.25, .98,  '(A3)', 'FontWeight', 'bold', 'FontSize', 8);
text(.47, .98,  '(A4)', 'FontWeight', 'bold', 'FontSize', 8);
text(.71, .98,  '(A5)', 'FontWeight', 'bold', 'FontSize', 8);
text(.25, .98-.16,  '(A6)', 'FontWeight', 'bold', 'FontSize', 8);
text(.47, .98-.16,  '(A7)', 'FontWeight', 'bold', 'FontSize', 8);
text(.71, .98-.16,  '(A8)', 'FontWeight', 'bold', 'FontSize', 8);

text(.002, .98-.33, '(B1)', 'FontWeight', 'bold', 'FontSize', 8);
text(.002, .9-.33,  '(B2)', 'FontWeight', 'bold', 'FontSize', 8);
text(.25, .98-.33,  '(B3)', 'FontWeight', 'bold', 'FontSize', 8);
text(.47, .98-.33,  '(B4)', 'FontWeight', 'bold', 'FontSize', 8);
text(.71, .98-.33,  '(B5)', 'FontWeight', 'bold', 'FontSize', 8);
text(.25, .98-.33-.16,  '(B6)', 'FontWeight', 'bold', 'FontSize', 8);
text(.47, .98-.33-.16,  '(B7)', 'FontWeight', 'bold', 'FontSize', 8);
text(.71, .98-.33-.16,  '(B8)', 'FontWeight', 'bold', 'FontSize', 8);

text(.002, .98-.66, '(C1)', 'FontWeight', 'bold', 'FontSize', 8);
text(.002, .9-.66,  '(C2)', 'FontWeight', 'bold', 'FontSize', 8);
text(.25, .98-.66,  '(C3)', 'FontWeight', 'bold', 'FontSize', 8);
text(.47, .98-.66,  '(C4)', 'FontWeight', 'bold', 'FontSize', 8);
text(.71, .98-.66,  '(C5)', 'FontWeight', 'bold', 'FontSize', 8);
text(.25, .98-.66-.16,  '(C6)', 'FontWeight', 'bold', 'FontSize', 8);
text(.47, .98-.66-.16,  '(C7)', 'FontWeight', 'bold', 'FontSize', 8);
text(.71, .98-.66-.16,  '(C8)', 'FontWeight', 'bold', 'FontSize', 8);