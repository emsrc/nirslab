function t = read_computrainer_output(filename)

% read_computrainer_output(filename)
%
% Read data exported from Computrainer in csv format
% 
% Returns a table object with variable names (i.e. columns) corresponding
% to the to the columns/fields in the Computrainer data 

t = readtable(filename);
t.Properties.UserData.SourceFilename = filename;

end

