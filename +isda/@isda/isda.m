% ISDA   Inter-state distance analysis
% 
%   D = ISDA creats an empty inter-state distance anlaysis object.
% 
%   D = ISDA(DATA) creats an inter-state distance anlaysis object with data
%   DATA. DATA should be a numerical vector with at least three elements.
% 
%   D = ISDA(~, 'PropertyName', value) creates an inter-state distance 
%   analysis object with the property 'PropertyName' and value VALUE.  
%   Supported property-value pairs include:
%       Data                -A numerical vector with at least three
%                            elements
%       Quality             -A numerical or logical vector with the same
%                            length of Data indicating the quality of data,
%                            1 means good quality and 0 means gaps
%       EmbedDimension      -A numerical scalar
%       TimeDelay           -A numerical scalar
%       Normalization       -A char array or string. Current supported
%                            normalization methods: 'minmax'
%       WorkInterval        -A numerical scalar
%                            WorkInterval determines the effect time
%                            interval
%       WorkRadius          -A numerical scalar
%                            In addition to WorkInterval, WorkRadius
%                            determines the radius of the effect around
%                            WorkInterval
%       DistanceFunction    -A char array or string. Supports all distance
%                            functions that pdist() supports
% 
%   ISDA methods
%       plotDist            -Plot isdaObj.DistanceMatrix
%                            supports one additional parameter which is the 
%                            handle of the axis
%       plotPdf             -Plot the pdf of isdaObj.InterStateDistance
%                            supports additional properties defined by
%                            ('PropertyName', value) pairs. Currently
%                            available PropertyName: 'PdfMethod'
%       partialDistEn       -Calculate partial distribution entropy
%                            supports additional properties defined by
%                            ('PropertyName', value) pairs. Currently
%                            available PropertyName: 'BinNumber'
% 
%   Copyright 2019- Peng Li
%
%   $Author: Peng Li
%   $Date:   Sep 04, 2019

classdef (CaseInsensitiveProperties = true, TruncatedProperties = true) isda < handle & matlab.mixin.Copyable
    % main properties, open to user
    properties (Dependent = true, SetObservable = true, AbortSet = true)
        Data
        Quality
        EmbedDimension
        TimeDelay
    end
    
    properties (Dependent = true, SetAccess = protected)
        StateSpace
    end
    
    properties (SetObservable = true, AbortSet = true)
        Normalization
    end
    
    properties (Dependent = true, SetObservable = true, AbortSet = true)
        WorkInterval
        WorkRadius
    end
    
    properties (SetObservable = true, AbortSet = true)
        DistanceFunction
    end
    
    % Data and Parameters listener
    properties (Transient = true, Hidden = true)
        DataParameterListener
        StateParameterListener
    end
    
    % cache, shadowing the true properties
    properties (SetAccess = protected, Hidden = true)
        Data_
        Quality_
        EmbedDimension_
        TimeDelay_
    end
    
    properties (Hidden = true, SetObservable = true, AbortSet = true)
        StateSpace_
    end
    
    properties (SetAccess = protected, Hidden = true)
        WorkInterval_
        WorkRadius_
    end
    
    properties (Dependent = true, SetAccess = protected)
        DistanceMatrix
        InterStateDistance
    end
    
    % cache dependent properties
    properties (Hidden = true)
        DistanceMatrix_
        InterStateDistance_
    end
    
    % property get and set
    methods
        function this = setprop(this, propName, propVal)
            this.(propName) = propVal;
        end
        
        function propval = getprop(this, propName)
            propval = this.(propName);
        end
        
        function set.Data(this, value)
            if ~(isnumeric(value) && isvector(value) && ~isscalar(value))
                error('The Data property should be a numerical vector.');
            end
            this.Data_ = value(:);
        end
        
        function out = get.Data(this)
            out = this.Data_;
        end
        
        function set.Quality(this, value)
            this.Quality_ = value(:);
        end
        
        function out = get.Quality(this)
            out = this.Quality_;
        end
        
        function set.EmbedDimension(this, value)
            if ~(isnumeric(value) && isscalar(value))
                error('The EmbedDimension property should be a numerical scalar.');
            end
            this.EmbedDimension_ = value;
        end
        
        function out = get.EmbedDimension(this)
            out = this.EmbedDimension_;
        end
        
        function set.TimeDelay(this, value)
            if ~(isnumeric(value) && isscalar(value))
                error('The TimeDelay property should be a numerical scalar.');
            end
            this.TimeDelay_ = value;
        end
        
        function out = get.TimeDelay(this)
            out = this.TimeDelay_;
        end
        
        function set.StateSpace(this, value)
            this.StateSpace_ = value;
        end
        
        function out = get.StateSpace(this)
            out = this.StateSpace_;
        end
        
        function set.WorkInterval(this, value)
            if ~(isnumeric(value) && isscalar(value))
                error('The WorkInterval property should be a numerical scalar.');
            end
            this.WorkInterval_ = value;
        end
        
        function out = get.WorkInterval(this)
            out = this.WorkInterval_;
        end
        
        function set.WorkRadius(this, value)
            if ~(isnumeric(value) && isscalar(value))
                error('The WorkRadius property should be a numerical scalar.');
            end
            this.WorkRadius_ = value;
        end
        
        function out = get.WorkRadius(this)
            out = this.WorkRadius_;
        end
        
        function set.Normalization(this, value)
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
        end
        
        function set.DistanceFunction(this, value)
            if ~isnumeric(value)
                this.DistanceFunction = char(value);
            else
                error('Value for property DistanceFunction should be a char array or string.');
            end
        end
        
        function set.InterStateDistance(this, value)
            this.InterStateDistance_ = value;
        end
        
        function out = get.InterStateDistance(this)
            out = this.InterStateDistance_;
        end
        
        function set.DistanceMatrix(this, value)
            this.DistanceMatrix_ = value;
        end
        
        function out = get.DistanceMatrix(this)
            out = this.DistanceMatrix_;
        end
    end
    
    % constructor
    methods
        function this = isda(varargin)
            % only data
            if nargin == 1 && isvector(varargin{1}) && numel(varargin{1}) >= 3 && ~ischar(varargin{1})
                this.Data = varargin{1};
            % property value pairs
            elseif nargin > 1
                this = init(this, varargin{:});
            end
            
            % parse quality
            if isempty(this.Quality)
                this.Quality = ones(size(this.Data));
            end
            
            try
                isda.isdaManager.embedReconstruct(this);
                isda.isdaManager.stDistance(this);
            end
            
            % add listener obj
            this.DataParameterListener  = isda.isdaManager.dataParameterChg(this);
            this.StateParameterListener = isda.isdaManager.stParameterChg(this);
        end
    end
    
    % methods, declarations only
    methods
        [v, x] = probabilityDensity(this, varargin);
        ha = plotDist(this, varargin);
        ha = plotPdf(this, varargin);
        en = robustEntropyRate(this, p0, varargin);
        en = partialSampEn(this, varargin);
        en = partialFuzzyEn(this, varargin);
    end
end