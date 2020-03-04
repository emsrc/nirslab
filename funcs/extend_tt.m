function tt = extend_tt(tt, time_to_add)

% extend_tt(tt, time_to_add)
%
% Extend timetable tt with empty rows, adding time_to_add seconds

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

if ~isduration(time_to_add)
    time_to_add = seconds(time_to_add);
end

% determine period as most frequent time difference between samples
period = mode(diff(tt.Properties.RowTimes));

% compute approximate time to add, rounding time upwards
approx_time_to_add = ceil(time_to_add/period)*period;

% construct new time vector
start_time = tt.Properties.RowTimes(end) + period;
end_time = tt.Properties.RowTimes(end) + approx_time_to_add;
new_times = start_time:period:end_time;

% turn off warning:
% "Warning: The assignment added rows to the table, but did not assign 
% values to all of the table's existing variables. Those variables have 
% been extended with rows containing default values."

warn_id = 'MATLAB:table:RowsAddedExistingVars';
warning('off', warn_id);

% add empty rows:
% We insert only the column in the middle and rely on matlab to insert 
% default values for the other columns.
% This assumes that there are no columns of type datetimes or cell
% in the middle
% FIXME Above solution is an unreliable hack...
tt(new_times, round(width(tt)/2)) = {0};

warning('on', warn_id);

end

