function ha = plotDist(this, varargin)
% PLOTDIST  plot the distance matrix of an ISDA object
% 

switch nargin
    case 1
        ha = createAxes;
    case 2
        ha = varargin{1};
end

dm = this.DistanceMatrix;
imagesc(ha, dm);
colormap(ha, 'gray');
set(ha, 'YDir', 'normal');
colorbar; caxis(ha, [0 1]);
axis(ha, 'square');
end

function ha = createAxes
ha = axes;
end