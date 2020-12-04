function en = partialSampEn(this, varargin)
% PARTIALSAMPEN calculate partial sample entropy for an ISDA object
% 
% $Author:  Peng Li
% $Date:    Dec 03, 2020
% 

% init
if nargin == 1
    error('THRESHOLD is required to calculate partial sample entropy.');
end

% to be expanded
ni = nargin - 1;
if mod(ni, 2) ~= 0
    error('Unmatched property-value pairs.');
end
for iA = 1:2:ni
    value = varargin{iA+1};
    switch lower(char(varargin{iA}))
        case 'threshold'
            rValue = value;
    end
end

% this.InterStateDistance is calculated based on normalized data while
% this. Data is on original scale
switch this.Normalization
    case 'minmax'
        ts = this.Data;
        ts = (ts - min(ts)) ./ (max(ts) - min(ts));
        rValue = rValue * nanstd(ts);
end

% prob @ m
cm = sum(this.InterStateDistance <= rValue)*2 ...
    / (size(this.StateSpace, 1)*(size(this.StateSpace, 1)-1));

% m -> m+1
thism1 = copy(this);
thism1.EmbedDimension = thism1.EmbedDimension + 1;
% listeners not copyable, embedReconstruction and stDistance need to be
% hardcoded here
isda.isdaManager.embedReconstruct(thism1);
isda.isdaManager.stDistance(thism1);

% prob @ m+1
ca = sum(thism1.InterStateDistance <= rValue)*2 ...
    / (size(thism1.StateSpace, 1)*(size(thism1.StateSpace, 1)-1));

en = -log(sum(ca) / sum(cm));