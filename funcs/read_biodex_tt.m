function tt = read_biodex_tt(filename)

% read_biodex_tt(filename)
%
% Read data exported from Biodex in txt format
% 
% Returns a timetable object with variable names (i.e. columns) corresponding
% to the columns/fields in the Biodex data 

% NB 'detectImportOptions' fails to handle 'POS (ANAT)' because of the
% space in the name
opts = detectImportOptions(filename);
header_lines = opts.DataLine(1) - 1;

% simply skip first 6 lines
tt = readtable(filename, 'HeaderLines', header_lines);

% original variable name 'POS (ANAT)' is not a valid name in Matlab
tt.Properties.VariableNames = {'TIME' 'TORQUE' 'POSITION' 'POS_ANAT' 'VELOCITY'};
tt.Properties.VariableUnits = {'mSec' 'N-M' 'Degrees' 'Degrees' 'DEG/SEC'};
tt.Properties.UserData.SourceFilename = filename;

% convert time to duration
tt.TIME = milliseconds(tt.TIME);

% read header lines and store (unparsed) in t.Properties.UserData.Header 
tt.Properties.UserData.Header = readlines(filename, header_lines);

tt = table2timetable(tt);

end

