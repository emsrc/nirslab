function tsc = read_velotron_tsc(filename)

% read_velotron_tsc(filename)
%
% Read data exported from Velotron as time series collection
% 
% Returns a time series collection where members are time series
% corresponding to the columns/fields in the Velotron data 

[col_names, samples] = read_velotron_output(filename);

time = samples(:, 1);
tsc = tscollection(time, 'Name', 'Velotron data');
tsc.TimeInfo.Units = 'milliseconds';

for i=2:length(col_names)
    ts = timeseries(samples(:,i), time, 'Name', col_names{i});
    ts.TimeInfo.Units = 'milliseconds';
    tsc = addts(tsc, ts);
end

