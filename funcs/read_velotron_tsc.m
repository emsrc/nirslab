function tsc = read_velotron_tsc(filename)

% read_velotron_tsc(filename)
%
% Read data exported from Velotron as time series collection
% 
% Returns a time series collection where members are time series
% corresponding to the columns/fields in the Velotron data 

t= read_velotron_output(filename);

tsc = tscollection(t.ms, 'Name', t.Properties.UserData.SourceFilename);
tsc.TimeInfo.Units = 'milliseconds';

for var=t.Properties.VariableNames(2:end)
    var = var{1};
    ts = timeseries(t{:,var}, t.ms, 'Name', var);
    ts.TimeInfo.Units = 'milliseconds';
    tsc = addts(tsc, ts);
end


%%%% OLD CODE:
% 
% [col_names, samples] = read_velotron_output(filename);
% 
% % remove subsequent sample with the same time
% % (values other columns may differ)
% [~, ia, ~] = unique(samples(:,1));
% samples =samples(ia, :);
% 
% time = samples(:, 1);
% tsc = tscollection(time, 'Name', 'Velotron data');
% tsc.TimeInfo.Units = 'milliseconds';
% 
% for i=2:length(col_names)
%     ts = timeseries(samples(:,i), time, 'Name', col_names{i});
%     ts.TimeInfo.Units = 'milliseconds';
%     tsc = addts(tsc, ts);
% end

