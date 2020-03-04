function tt = read_computrainer_tt(filename)

% read_computrainer_tt(filename)
%
% Read data exported from Computrainer in csv format
% 
% Returns a timetable object with variable names (i.e. columns) corresponding
% to the to the columns/fields in the Computrainer data 

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

tt = readtable(filename);
tt.Properties.UserData.SourceFilename = filename;
time = seconds(tt.secs);
tt = table2timetable(tt, 'RowTime', time);

end

