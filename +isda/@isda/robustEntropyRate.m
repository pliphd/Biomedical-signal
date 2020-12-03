function en = robustEntropyRate(this, p0, varargin)
% ROBUSTENTROPYRATE robust estimation of entropy rate for an ISDA object
% 

% dimension: m
[cumulativeDensity, x]   = this.probabilityDensity('Function', 'cdf', varargin{:});

% dimension: m+1
copythis = copy(this);
copythis.EmbedDimension  = this.EmbedDimension + 1;
% listeners not copyable, embedReconstruction and stDistance need to be
% hardcoded here
isda.isdaManager.embedReconstruct(copythis);
isda.isdaManager.stDistance(copythis);
[cumulativeDensity1, x1] = copythis.probabilityDensity('Function', 'cdf', varargin{:});

% estimation
[~, ind]  = min(abs(cumulativeDensity  - p0));
lambda    = x(ind);
[~, ind1] = min(abs(cumulativeDensity1 - p0));
lambda1   = x1(ind1);
en        = (lambda1 - lambda) / lambda;