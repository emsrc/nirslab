function tt = read_metalyzer_tt(filename)

% read_metalyzer_tt(filename)
%
%
% read data originating from Metalyzer 
%
% filename:     'char'
%               xlsx file with data, originating from Metalyzer,
%               exported with MS Excel
%
% Return a timetable object corresponding to sample data.
% Source filename is stored in tt.Properties.UserData.SourceFilename.
% Preamble data is stored in tt.Properties.UserData.Preamble.


% NB This is a quick & dirty solution for the time being,
% which relies on reading the table twice.
% Probably not a very robust approach.
% The proper way would be to directly parse the xml file exported 
% by Metalyzer with Matlab's xmlread function.

% First time reading the file in order to find start and end rows 
% of actual samples.
t1 = readtable(filename, 'ReadVariableNames', false);

% Find start and end row of the samples
% +1 because readtable skips the first emply line in the spreadsheet...
samples_start_row = find(strcmp('t', t1.Var1)) + 3;
samples_end_row = size(t1,1) + 1;
range = sprintf('%d:%d', samples_start_row, samples_end_row);

% Second time reading the file, restricted to range containing the samples,
% in order to read the variables in their proper format.
t2 = readtable(filename, 'Range', range, 'ReadVariableNames', false);

t2.Properties.UserData.SourceFilename = filename;

t2.Properties.VariableNames = matlab.lang.makeValidName(t1{samples_start_row - 3, :});
t2.Properties.VariableUnits = t1{samples_start_row - 2, :};

% just dumping the header as a table under UserData for possibe future
% processing (if any)
t2.Properties.UserData.Preamble = t1(1:samples_start_row - 4, 1:4);

% use ID as description
ID_line = find(strcmp('ID', t1.Var1));
t2.Properties.Description = t1{ID_line, 3}{1};

% readtable reads time column 't' in format 'HH:MM:SS' as a string,
% so convert to duration (seconds)
[Y,M,D,H,MN,S] = datevec(t2.t);
t2.Time = seconds(MN*60+S);

tt = table2timetable(t2);

end

