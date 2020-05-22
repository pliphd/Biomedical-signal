% PHYSIOLOGICALTIMESERIES   Create a physiological time series object.
%   This is from subclassing time series class
%   Pre-defined quality Code and Description
%                       ----     -----------
%                         -1     Gap
%                          0     Awake
%                          1     Asleep
%                         10     Resting
%                         11     Exercising
%                         12     Recovering
%                       --------------------
%
%   Copyright 2018-2018 Peng Li
%
%   $Author: Peng Li
%   $Date:   Jan 22, 2018
%

classdef physiologicaltimeseries < timeseries
    properties (Dependent = true)
        Window;
    end
    
    properties
        WindowInfo = [];
    end
    
    properties (SetAccess = protected, Hidden = true)
        Window_ = [];
    end
    
    methods
        function this = physiologicaltimeseries(varargin)
            this@timeseries(varargin{:});
            
            this.QualityInfo.Code        = [-1 0 1 10 11 12];
            this.QualityInfo.Description = {'Gap', 'Asleep', 'Awake', 'Resting', 'Exercising', 'Recovering'};
            
            this.WindowInfo = ptsdata.windmetadata;
        end
        
        function this = set.Window(this, input)
            if ~isa(input, 'ptsdata.windmetadata')
                this.Window_ = input;
            else
                if input.restrict
                    if input.qualitydependent
                        % tsQuality = this.Quality;
                    else
                        %
                    end
                else
                    if input.qualityaswindow
                        this.Window_ = this.quality2window(this.Quality);
                    else
                        this.Window_ = [this.Time(1) this.Time(end)];
                    end
                end
            end
        end
        
        function outwindow = get.Window(this)
            outwindow = this.Window_;
        end
        
        function this = set.WindowInfo(this, input)
            if isa(input, 'struct')
                this.WindowInfo = ptsdata.windmetadata.loadobj(input);
            elseif isa(input, 'ptsdata.windmetadata')
                this.WindowInfo = input;
            else
                error('Not valid ptsdata.windmetadata input.');
            end
        end
    end
    
    methods (Access = protected)
        % QualityAsWindow
        function outwindow = quality2window(this, Quality)%#ok
            incT = diff([500; Quality; 500]);
            truc = find(incT ~= 0);
            outwindow = [truc(1:end-1) truc(2:end)-1];
        end
    end
    
    methods
        pts = getinterestedsample(this, StartTime, SamplesOrDuration);
    end
end