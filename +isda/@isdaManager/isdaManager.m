classdef isdaManager
    %ISDAMANAGER
    % 
    %   Copyright 2019- Peng Li
    %
    %   $Author: Peng Li
    %   $Date:   Sep 04, 2019
    % 
    methods (Static = true)
        function embedReconstruct(isdaObj, ~)
            if ~(~isempty(isdaObj.EmbedDimension) && ~isempty(isdaObj.TimeDelay) && ~isempty(isdaObj.Normalization))
                return;
            end
            
            % rescaling
            switch isdaObj.Normalization
                case 'minmax'
                    ts = isdaObj.Data;
                    ts = (ts - min(ts)) ./ (max(ts) - min(ts));
                case 'zscore'
                    ts = zscore(isdaObj.Data);
            end
            
            % reconstruction
            N   = length(isdaObj.Data) - (isdaObj.EmbedDimension-1)*isdaObj.TimeDelay;
            ind = hankel(1:N, N:length(isdaObj.Data));
            isdaObj.StateSpace_ = ts(ind(:, 1:isdaObj.TimeDelay:end));
            
            % remove state related to gap points
            qualityStateSpace   = isdaObj.Quality(ind(:, 1:isdaObj.TimeDelay:end));
            gapStateIndicator   = any(~qualityStateSpace, 2);
            isdaObj.StateSpace_(gapStateIndicator, :) = [];
        end
        
        function stDistance(isdaObj, ~)
            if isempty(isdaObj.DistanceFunction) || isempty(isdaObj.WorkInterval) || isempty(isdaObj.WorkRadius)
                return;
            end
            
            dm   = squareform(pdist(isdaObj.StateSpace, isdaObj.DistanceFunction));
            
            if (isdaObj.WorkInterval+isdaObj.WorkRadius) >= size(dm, 1)
                dEye = triu(ones(size(dm)), max(isdaObj.WorkInterval-isdaObj.WorkRadius, 1));
            else
                dEye = triu(ones(size(dm)), max(isdaObj.WorkInterval-isdaObj.WorkRadius, 1)) ...
                    - triu(ones(size(dm)), isdaObj.WorkInterval+isdaObj.WorkRadius+1);
            end
            
            isdaObj.DistanceMatrix_     = dm .* dEye;
            isdaObj.InterStateDistance_ = dm(dEye & ones(size(dm)));
        end
        
        % methods
        function lh = dataParameterChg(isdaObj)
            lh = addlistener(isdaObj, ...
                {'Data', 'Quality', 'EmbedDimension', 'TimeDelay', 'Normalization'}, ...
                'PostSet', ...
                @(src, evt) isda.isdaManager.embedReconstruct(isdaObj));
        end
        
        function lh = stParameterChg(isdaObj)
            lh = addlistener(isdaObj, ...
                {'StateSpace_', 'WorkInterval', 'WorkRadius', 'DistanceFunction'}, ...
                'PostSet', ...
                @(src, evt) isda.isdaManager.stDistance(isdaObj));
        end
    end
end