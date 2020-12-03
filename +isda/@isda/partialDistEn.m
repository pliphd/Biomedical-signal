function en = partialDistEn(this, varargin)
% PARTIALDISTEN calculate partial distribution entropy for an ISDA object
% 

% init
if nargin == 1
    error('BinNumber is required to calculate partial distribution entropy.');
end

% to be expanded
ni = nargin - 1;
if mod(ni, 2) ~= 0
    error('Unmatched property-value pairs.');
end
for iA = 1:2:ni
    value = varargin{iA+1};
    switch lower(char(varargin{iA}))
        case 'binnumber'
            binNumber    = value;
        case 'pdfoption'
            pdfOption    = value;
    end
end

if exist('pdfOption', 'var') ~= 1
    pdfOption = 'histogram'; % default
end

if strcmp(pdfOption, 'histogram') && exist('binNumber', 'var') ~= 1
    error('BinNumber is required if using histogram option to calculate partial distribution entropy.');
end

switch lower(pdfOption)
    case 'histogram'
        % pdf
        binEdge = linspace(0, 1, binNumber+1);
        valPdf  = histcounts(this.InterStateDistance, 'BinEdges', binEdge, 'Normalization', 'probability');
        
        % % commented out // match old DistEn -- using hist
        % valPdf = hist(this.InterStateDistance, linspace(0, 1, binNumber)); valPdf = valPdf ./ sum(valPdf);
        
        % DistEn
        en = -sum(valPdf.*log2(valPdf+eps)) / log2(binNumber);
    case 'kernel'
        dv  = this.InterStateDistance; dv(dv == 0) = eps;
        p_d = fitdist(dv, 'Kernel', 'Support', 'positive', 'Kernel', 'box');
        x   = linspace(0, 1, 256);
        p   = pdf(p_d, x);
        m   = unifpdf(x, 0, 1);
        en  = (log2(256) - trapz(x, p.*log2((p+eps)./m))) ./ log2(256);
end