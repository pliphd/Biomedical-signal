function [y, x] = probabilityDensity(this, varargin)
% PROBABILITYDENSITY  calculate the probability density function or
%     cumulative probability function of an isda object
% 

% init by default
fFunction = 'pdf';
pdfOption = 'histogram';
binNumber = 128;

if nargin > 1
    ni = nargin - 1;
    if mod(ni, 2) ~= 0
        error('Unmatched property-value pairs.');
    end
    for iA = 1:2:ni
        value = varargin{iA+1};
        switch lower(char(varargin{iA}))
            case 'function'
                fFunction = value;
            case 'pdfoption'
                pdfOption = value;
            case 'binnumber'
                binNumber = value;
        end
    end
end

switch lower(char(pdfOption))
    case 'histogram'
        if exist('binNumber', 'var') ~= 1
            warning('BinNumber needs to be defined to support histogram. Default BinNumber = 128 was used.');
            binNumber = 128;
        end
        binEdge = linspace(min(this.InterStateDistance), max(this.InterStateDistance), binNumber+1);
        h = histcounts(this.InterStateDistance, 'BinEdges', binEdge, 'Normalization', fFunction);
        x = binEdge(1:end-1) + diff(binEdge) ./ 2;
        y = h;
    case 'kernel'
        p_d = fitdist(this.InterStateDistance+eps, 'Kernel', 'Support', 'positive', 'Kernel', 'box');
        x   = linspace(0, max(this.InterStateDistance), 256);
        y   = feval(fFunction, p_d, x);
end
end