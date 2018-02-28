function tsc = read_biodex_tsc(filename)

% read_biodex_tsc(filename)
%
% Read data exported from Biodex as time series collection
% 
% Returns a time series collection where members are time series
% corresponding to the columns/fields in the Biodex data 

t= read_biodex_output(filename);

tsc = tscollection(t.TIME, 'Name', t.Properties.UserData.SourceFilename);
tsc.TimeInfo.Units = 'milliseconds';

for i=2:length(t.Properties.VariableNames)
    var = t.Properties.VariableNames{i};
    ts = timeseries(t{:,var}, t.TIME, 'Name', var);
    ts.TimeInfo.Units = 'milliseconds';
    ts.DataInfo.Units = t.Properties.VariableUnits{i};
    tsc = addts(tsc, ts);
end

end

