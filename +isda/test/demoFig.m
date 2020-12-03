N = 1000;
sig1 = isda.isda(randn(N, 1), 'EmbedDimension', 3, 'TimeDelay', 1, ...
    'Normalization', 'minmax', 'DistanceFunction', 'chebychev');
sig1.WorkInterval = 200;
sig1.WorkRadius   = 100;

%%
close all;
Pos = CenterFig(8, 6, 'centimeter');
figure('Color', 'w', 'Units', 'centimeter', 'Position', Pos);
axes;
sig1.plotDist(gca);
xlabel('\it{i}');
ylabel('\it{j}');
axis square

%%
close all;
Pos = CenterFig(8, 5, 'centimeter');
figure('Color', 'w', 'Units', 'centimeter', 'Position', Pos);
axes;
h = sig1.plotPdf(gca, 'BinNumber', 32, 'PdfMethod', 'histogram');
h.Children.Normalization = 'count';
h.Children.FaceColor = [.5 .5 .5];
xlabel('\it{d}');
ylabel('??\it{p}');
text(.8, 8000, '\it{B}\rm???');