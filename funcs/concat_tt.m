function tt3 = concat_tt(tt1, tt2)

% concat_tt(t1, t2)
%
% Returns vertical concatenation of timetables tt1 and tt2,
% correcting the time of tt2 to match that of tt1. 
% 
% Assumes both timetables have the same sample frequency. 

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

% determine period as most frequent time difference between samples
period = mode(diff(tt1.Properties.RowTimes));

tt1_end_time = tt1.Properties.RowTimes(end);

tt2_start_time = tt2.Properties.RowTimes(1);

tt2_time_offset = tt1_end_time + period - tt2_start_time;

tt2.Properties.RowTimes = tt2.Properties.RowTimes + tt2_time_offset; 

tt3 = [tt1; tt2];

end

