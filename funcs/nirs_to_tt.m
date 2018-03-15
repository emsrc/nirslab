function tt = nirs_to_tt(test)

% nirs_to_tt(test) 
%
% Convert a Nirs test to a timetable.
% E.g. nirs_to_tsc(data.norm.nirsO.test(1)).
% 
% Returns a timetable according to the columns/fields in the Nirs data.
% Time in miliseconds is computed from sample numbers and sample rate.


% compute time in milliseconds from sample numbers and sample rate
samp_num = test.samples{1};
time = milliseconds(samp_num * (1000 / test.export_sample_rate));

% mangle orignal columns to obtain valid Matlab names
varnames = matlab.lang.makeValidName(test.legend(1:end));

tt = timetable(time, test.samples{1:end}, 'VariableNames', varnames);

% copy some metadata in UserData field
tt.Properties.UserData.events =  test.events;
tt.Properties.UserData.export_sample_rate = test.export_sample_rate;
tt.Properties.UserData.legend = test.legend;
tt.Properties.UserData.events =  test.events;

end

