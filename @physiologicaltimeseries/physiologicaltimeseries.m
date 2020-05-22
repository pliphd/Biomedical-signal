% PHYSIOLOGICALTIMESERIES   Create a physiological time series object.
% 
%   This is from subclassing time series class
% 
%   PTS = PHYSIOLOGICALTIMESERIES(DATA, TIME) creates a physiological time
%   series object PTS using data DATA and time in TIME. Note: In creating 
%   PHYSIOLOGICALTIMESERIES, TIME is restricted to datenum to speed up the
%   creation of an object using long data sets.
%
%   Time-related parameters for all PHYSIOLOGICALTIMESERIES methods should 
%   be in datetime format.
% 
%   Copyright 2018- Peng Li
%
%   $Author: Peng Li
%   $Date:   Mar 01, 2018
%

classdef physiologicaltimeseries < timeseries
    properties (SetAccess = protected)
        TrueTime = [];
    end
    
    methods
        function this = physiologicaltimeseries(varargin)
            % parse inputs: TIME
            compatible = 0;
            if nargin >= 2
                checktime = varargin{2};
                if ischar(checktime) && ~(strcmpi(checktime, 'name') || strcmpi(checktime, 'istimefirst') || strcmpi(checktime, 'isdatenum'))
                    error('Second parameter should be datenum or should specify properties of physiological time series (''Name'', ''IsTimeFirst'', or ''IsDatenum).');
                elseif ~ischar(checktime) && ~isa(checktime, 'double')
                    error('TIME is restricted to datenum in order to speed up the creation of an object with long data.');
                elseif isa(checktime, 'double')
                    % convert time to relative datenum (relative to the first
                    % sample)
                    compatible = 1;
                    TrueTime   = datetime(checktime, 'ConvertFrom', 'datenum', 'Format', 'yyyy/MM/dd HH:mm:ss.SSS');
                    StartDate  = datestr(checktime(1), 'yyyy/mm/dd HH:MM:ss.FFF');
                    checktime  = checktime - checktime(1);
                    
                    varargin{2} = checktime;
                end
            end
            
            % creation
            this@timeseries(varargin{:});
            
            if compatible
                this.TimeInfo.Units     = 'days';
                this.TimeInfo.StartDate = StartDate;
                this.TrueTime           = TrueTime;
            end
        end
    end
    
    methods
        pts = getinterestedsample(this, StartTime, SamplesOrDuration);
    end
end