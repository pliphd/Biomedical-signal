function this = init(this, varargin)
% INIT  Initialize an ISDA object
%
%   TBA
% 
%   See also ISDA
%

%   Copyright 2019- Peng Li
% 

ni = nargin - 1;

% parse PV pairs
if ~ischar(varargin{1})
    if isvector(varargin{1}) && ~isscalar(varargin{1})
        this.Data = varargin{1};
        pvStart   = 2;
    else
        error('Incorrect parameter.');
    end
else
    pvStart = 1;
end

if mod(ni - pvStart + 1, 2) ~= 0
    error('Missing property names or values.');
end
for iP = pvStart:2:ni
    value = varargin{iP+1};
    switch lower(char(varargin{iP}))
        case 'data'
            if isnumeric(value) && isvector(value) && ~isscalar(value)
                this.Data = value(:);
            else
                error('The Data property should be a numerical vector.');
            end
        case 'quality'
            this.Quality = value(:);
        case {'embeddimension', 'timedelay', 'workinterval', 'workradius'}
            if isnumeric(value) && isscalar(value)
                this.(lower(char(varargin{iP}))) = value;
            else
                error(['The ' char(varargin{iP}) ' property should be a numerical scalar.']);
            end
        case {'normalization', 'norm'}
            if isstring(value)
                value = char(value);
            end
            if ~isnumeric(value)
                switch lower(value)
                    case {'minmax', 'zscore'}
                        this.Normalization = value;
                    otherwise
                        error(['Normalization method ' value ' not supported.']);
                end
            else
                error('Value for property Normalization should be a char array or string.');
            end
        case 'distancefunction'
            if ~isnumeric(value)
                this.DistanceFunction = char(value);
            else
                error('Value for property DistanceFunction should be a char array or string.');
            end
    end
end