function tt = read_lode_tt(filename)

% read_lode_tt(filename)
%
%
% read data exported from Lode as Excel spreadsheet
%
% filename:     'char'
%               file with Excalibur data
%
% Return a timetable object corresponding to sample data in the 3rd tab.
% Source filename is stored in tt.Properties.UserData.SourceFilename.
% Subject tab data is stored in tt.Properties.UserData.Subject.
% Devices tab data is stored in tt.Properties.UserData.Devices.
% LEM tab data is stored in tt.Properties.UserData.LEM.

table = readtable(filename, 'Sheet', 3);

table.Time = seconds(table.Time);

tt = table2timetable(table);

tt.Properties.UserData.SourceFilename = filename;
tt.Properties.UserData.Subject = readtable(filename, 'Sheet', 'Subject');
tt.Properties.UserData.Devices = readtable(filename, 'Sheet', 'Devices');
tt.Properties.UserData.LEM = readtable(filename, 'Sheet', 'LEM', 'ReadVariableNames', false);
tt.Properties.Description = tt.Properties.UserData.Subject.ID{1};

end

