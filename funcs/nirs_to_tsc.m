function tsc = nirs_to_tsc(test, name)

% nirs_to_tsc(test) 
%
% Convert a Nirs test to a time series collection.
% E.g. nirs_to_tsc(data.norm.nirsO.test(1), 'test1').
% 
% Returns a time series collection where members are time series
% corresponding to the columns/fields in the Nirs data.
% Time in miliseconds is computed from sample numbers and sample rate.

% compute time in milliseconds from sample numbers and sample rate
samp_num = test.samples{1};
time = samp_num * (1000 / test.export_sample_rate);

tsc = tscollection(time, 'Name', name);
tsc.TimeInfo.Units = 'milliseconds';

for i=1:test.num_cols-1
    var = test.legend{i};
    ts = timeseries(test.samples{i}, time, 'Name', var);
    ts.TimeInfo.Units = 'milliseconds';
    tsc = addts(tsc, ts);
end

% FIXME: why this exception for events column?
i = i + 1;
var = test.legend{i};
col = cell2table(test.samples{i});
ts = timeseries(col, time, 'Name', var);
ts.TimeInfo.Units = 'milliseconds';
tsc = addts(tsc, ts);

tsc.TimeInfo.UserData.events =  test.events;
tsc.TimeInfo.UserData.export_sample_rate = test.export_sample_rate; 

end

