function t = read_biodex_output(filename)

% read_biodex_output(filename)
%
% Read data exported from Biodex in txt format
% 
% Returns a table object with variable names (i.e. columns) corresponding
% to the to the columns/fields in the Biodex data 

% simply skip first 6 lines
t = readtable(filename, 'HeaderLines', 6);

% original variable name 'POS (ANAT)' is not a valid name in Matlab
t.Properties.VariableNames = {'TIME' 'TORQUE' 'POSITION' 'POS_ANAT' 'VELOCITY'};
t.Properties.VariableUnits = {'mSec' 'N-M' 'Degrees' 'Degrees' 'DEG/SEC'};
t.Properties.UserData.SourceFilename = filename;

% Note: tried to use function 'detectImportOptions', 
% but it fails to handle 'POS (ANAT)' because of the space in the name 

end

