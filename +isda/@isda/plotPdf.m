function ha = plotPdf(this, varargin)
% PLOTPDF  plot the probability density function of an ISDA object
% 

% init
if nargin == 1
    ha        = createAxes;
    pdfOption = 'histogram';
    binNumber = 128;
else
    ni = nargin - 1;
    if ni == 1
        ha = varargin{1};
    elseif mod(ni, 2) ~= 0
        if isa(varargin{1}, 'handle') && strcmp(get(varargin{1}, 'Type'), 'axes')
            ha = varargin{1};
            st = 2;
        else
            error('Unmatched property-value pairs.');
        end
    else
        st = 1;
    end
    for iA = st:2:ni
        value = varargin{iA+1};
        switch lower(char(varargin{iA}))
            case 'pdfoption'
                pdfOption = value;
            case 'binnumber'
                binNumber = value;
        end
    end
end

if exist('ha', 'var') ~= 1
    ha = createAxes;
end

switch lower(char(pdfOption))
    case 'histogram'
        if exist('binNumber', 'var') ~= 1
            warning('BinNumber needs to be defined to support histogram. Default BinNumber = 128 was used.');
            binNumber = 128;
        end
        binEdge = linspace(0, 1, binNumber+1);
        histogram(ha, this.InterStateDistance, 'BinEdges', binEdge, 'Normalization', 'probability');
    case 'kernel'
        p_d = fitdist(this.InterStateDistance+eps, 'Kernel', 'Support', 'positive', 'Kernel', 'box');
        x   = linspace(0, 1, 256);
        y   = pdf(p_d, x);
        plot(x, y);
end
end

function ha = createAxes
ha = axes;
end