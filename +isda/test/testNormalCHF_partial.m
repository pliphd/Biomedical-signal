% NN interval: NSR vs CHF
%    NN length: 5 min
%    to specify start time in program
% 
% $Author:  Peng Li
%           School of Control Science and Engineering
%               Shandong University
%               pli@sdu.edu.cn
%           Division of Sleep and Circadian Disorders
%               Brigham and Women's Hospital
%               Harvard Medical School
%               pli9@bwh.harvard.edu
% $Date:    Oct 7, 2019
%               Using isda
% 
clc; clear; close all;

%% config
% NN data path
if ispc
    nsrpath = 'C:\Users\pliph\Data\NN intervals\MIT-BIH NSR NN intervals with starting time\NN intervals';
    chfpath = 'C:\Users\pliph\Data\NN intervals\BIDMC CHF NN intervals with starting time\NN intervals';
else
    nsrpath = '../../NN intervals/MIT-BIH NSR NN intervals with starting time/NN intervals';
    chfpath = '../../NN intervals/BIDMC CHF NN intervals with starting time/NN intervals';
end

len = 5;         % in min;
Pt  = len*60*.5; % minimum consecutive intervals as criteria of inclusion

nn_length = minutes(len);

starttime = datetime('20:00:00', 'InputFormat', 'HH:mm:ss'):minutes(len):datetime('20:00:00', 'InputFormat', 'HH:mm:ss')+hours(8);
starttime(end) = [];

%% nsr
gp      = 'NSR';
allfile = dir(fullfile(nsrpath, '1*.txt'));

% ++++++++++++++++ 1. pre-allocation +++++++++++++++++++++++++++++++++++++
workInterval = 100:-5:5;
workRadius   = 100:-5:5;

pDistEn = nan(length(starttime), length(allfile), length(workInterval), length(workRadius));

obj = isda.isda;
obj.EmbedDimension   = 3;
obj.TimeDelay        = 1;
obj.Normalization    = 'minmax';
obj.DistanceFunction = 'chebychev';

% ++++++++++++++++ 2. start time +++++++++++++++++++++++++++++++++++++++++
for iS = 1:length(starttime)
    disp(['set ' num2str(iS) '; start time: ' datestr(starttime(iS))]);
    
    % ++++++++++++++++ 3. all subjects +++++++++++++++++++++++++++++++++++
    for ia  = 1:length(allfile)
        curfile = allfile(ia).name;
        
        disp(curfile);
        
        nn_orig = readtable(fullfile(nsrpath, curfile), 'ReadVariableNames', 0, 'Delimiter', '\t', 'DatetimeType', 'datetime', 'Format', '%.6f\t%{yyyy/MM/dd HH:mm:ss.SSS}D');
        pts = physiologicaltimeseries(nn_orig.(1), datenum(nn_orig.(2)));
        
        curstarttime1 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate)),   'ConvertFrom', 'datenum');
        curstarttime2 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate))+1, 'ConvertFrom', 'datenum');
        
        spts1 = getinterestedsample(pts, curstarttime1, nn_length);
        spts2 = getinterestedsample(pts, curstarttime2, nn_length);
        
        if ~isempty(spts1.Data)
            nn = spts1.Data;
            nt = spts1.Time;
            st = curstarttime1;
        else
            nn = spts2.Data;
            nt = spts2.Time;
            st = curstarttime2;
        end
        
        if length(nn) <= 10
            continue;
        end
        
        obj.Data = nn;
        
        for iI   = 1:length(workInterval)
            obj.WorkInterval = workInterval(iI);
            for iR = 1:length(workRadius)
                obj.WorkRadius = workRadius(iR);
                if length(obj.InterStateDistance) >= 64*8
                    binNumber = 64;
                elseif length(obj.InterStateDistance) >= 32*8
                    binNumber = 32;
                elseif length(obj.InterStateDistance) >= 16*8
                    binNumber = 16;
                else
                    binNumber = 8;
                end
                pDistEn(iS, ia, iI, iR) = obj.partialDistEn('BinNumber', binNumber);
            end
        end
    end
end
eval(['pDistEn_' gp ' = pDistEn;']);

%% chf
gp      = 'CHF';
allfile = dir(fullfile(chfpath, 'chf*.txt'));

% ++++++++++++++++ 1. pre-allocation +++++++++++++++++++++++++++++++++++++
workInterval = 100:-5:5;
workRadius   = 100:-5:5;

pDistEn = nan(length(starttime), length(allfile), length(workInterval), length(workRadius));

obj = isda.isda;
obj.EmbedDimension   = 3;
obj.TimeDelay        = 1;
obj.Normalization    = 'minmax';
obj.DistanceFunction = 'chebychev';

% ++++++++++++++++ 2. start time +++++++++++++++++++++++++++++++++++++++++
for iS = 1:length(starttime)
    disp(['set ' num2str(iS) '; start time: ' datestr(starttime(iS))]);
    
    % ++++++++++++++++ 3. different subjects +++++++++++++++++++++++++++++
    for ia  = 1:length(allfile)
        curfile = allfile(ia).name;
        
        disp(curfile);
        
        nn_orig = readtable(fullfile(chfpath, curfile), 'ReadVariableNames', 0, 'Delimiter', '\t', 'DatetimeType', 'datetime', 'Format', '%d\t%{yyyy/MM/dd HH:mm:ss.SSS}D');
        pts = physiologicaltimeseries(nn_orig.(1), datenum(nn_orig.(2)));
        
        curstarttime1 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate)),   'ConvertFrom', 'datenum');
        curstarttime2 = datetime(datenum(starttime(iS)) - floor(datenum(starttime(iS))) + floor(datenum(pts.TimeInfo.StartDate))+1, 'ConvertFrom', 'datenum');
        
        spts1 = getinterestedsample(pts, curstarttime1, nn_length);
        spts2 = getinterestedsample(pts, curstarttime2, nn_length);
        
        if ~isempty(spts1.Data)
            nn = double(spts1.Data);
            nt = spts1.Time;
            st = curstarttime1;
        else
            nn = double(spts2.Data);
            nt = spts2.Time;
            st = curstarttime2;
        end
        
        obj.Data = nn;
        
        if length(nn) <= 10
            continue;
        end
        
        for iI   = 1:length(workInterval)
            obj.WorkInterval = workInterval(iI);
            for iR = 1:length(workRadius)
                obj.WorkRadius = workRadius(iR);
                if length(obj.InterStateDistance) >= 64*8
                    binNumber = 64;
                elseif length(obj.InterStateDistance) >= 32*8
                    binNumber = 32;
                elseif length(obj.InterStateDistance) >= 16*8
                    binNumber = 16;
                else
                    binNumber = 8;
                end
                pDistEn(iS, ia, iI, iR) = obj.partialDistEn('BinNumber', binNumber);
            end
        end
    end
end

eval(['pDistEn_' gp ' = pDistEn;']);