% WINDMETADATA   Create windmetadata object
%
%   Copyright 2018-2018 Peng Li
%
%   $Author: Peng Li
%   $Date:   Jan 23, 2018
%

classdef (CaseInsensitiveProperties = true, TruncatedProperties = true) windmetadata
    properties
        unit             = 'point';
        startfixed       = false;
        starttime        = 1;
        lengthfixed      = false;
        length           = inf;
        overlap          = 0;
        qualitydependent = false;
    end

    properties (Hidden = true, GetAccess = protected, SetAccess = protected)
        Version = 0.0;
    end
    
    methods (Static = true)
        function this = loadobj(obj)
            if isstruct(obj)
                this = ptsdata.windmetadata;
                if isfield(obj, 'unit')
                    this.unit = obj.unit;
                end
                if isfield(obj, 'startfixed')
                    this.startfixed = obj.startfixed;
                end
                if isfield(obj, 'starttime')
                    this.starttime = obj.starttime;
                end
                if isfield(obj, 'lengthfixed')
                    this.lengthfixed = obj.lengthfixed;
                end
                if isfield(obj, 'length')
                    this.length = obj.length;
                end
                if isfield(obj, 'overlap')
                    this.overlap = obj.overlap;
                end
                if isfield(obj, 'qualitydependent')
                    this.qualitydependent = obj.qualitydependent;
                end
            elseif isa(obj, 'ptsdata.windmetadata')
                this = obj;
            else
                error(message('MATLAB:ptsdata:windmetadata:loadobj:invloadqualmetadata'));
            end
        end
    end
end



