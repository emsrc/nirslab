function tsc = read_computrainer_tsc(filename)

% read_computrainer_tsc(filename)
%
% Read data exported from Computrainer as time series collection
% 
% Returns a time series collection where members are time series
% corresponding to the columns/fields in the Computrainer data 

t = read_computrainer_output(filename);

tsc = tscollection(t.secs, 'Name', t.Properties.UserData.SourceFilename);
tsc.TimeInfo.Units = 'seconds';

for var=t.Properties.VariableNames(2:end)
    var = var{1};
    ts = timeseries(t{:,var}, t.secs, 'Name', var);
    ts.TimeInfo.Units = 'seconds';
    tsc = addts(tsc, ts);
end

end

