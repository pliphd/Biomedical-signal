function pts = getinterestedsample(this, StartTime, SamplesOrDuration)
%GETINTERESTEDSAMPLE Extract samples from a physiologicaltimeseries obj
% starting with a specific start time and with a specific sample size or
% duration into a new physiologicaltimeseries obj
% 
%   SPTS = GETINTERESTEDSAMPLE(PTS, STARTTIME, SAMPLESORDURATION) extracts
%   samples from PTS starting from STARTTIME and with longth of
%   SAMPLESORDURATION to a new physiologicaltimeseries object SPTS.
% 
%   Copyright 2018- Peng Li
%
%   $Author: Peng Li
%   $Date:   Mar 01, 2018
%

% parse inputs
if ~isa(StartTime, 'datetime')
    error(['Time related inputs for all methods of physiologicaltimeseries obj are ' ...
        'restricted to datetime objects. Consider to transform to fake datetime objects ' ...
        'if necessary.']);
end

StartValue = timeseries.tsgetrelativetime(datestr(StartTime), this.TimeInfo.StartDate, this.TimeInfo.Units);
StartIndex = find(this.Time >= StartValue);

if isa(SamplesOrDuration, 'duration')
    EndTime  = StartTime + SamplesOrDuration;
    EndValue = timeseries.tsgetrelativetime(datestr(EndTime), this.TimeInfo.StartDate, this.TimeInfo.Units);
    EndIndex = find(this.Time < EndValue);
    Index    = intersect(StartIndex, EndIndex);
elseif isa(SamplesOrDuration, 'double')
    Index    = StartIndex(1:min([SamplesOrDuration, length(StartIndex)]));
else
    error('3rd input only accepts a duration object or a double integer!');
end

if ~isempty(Index)
    pts = getsamples(this, Index);
    pts.TrueTime = this.TrueTime(Index);
else
    pts = physiologicaltimeseries;
end