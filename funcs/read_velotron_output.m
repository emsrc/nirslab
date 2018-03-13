function t = read_velotron_output(filename)

% read_velotron_output(filename)
%
% Read data exported from Velotron
% 
% Returns a table object with variable names (i.e. columns) corresponding
% to the to the columns/fields in the Velotron data 

% TODO parse user data

fid = fopen(filename, 'r');
line_count = 0;

% skip over [USER DATA] section and read number of records
while (~feof(fid)) 
    line = fgetl(fid);
    line_count = line_count + 1;
    if regexp(line, '^number of records')
        % n_records = textscan(line, 'number of records = %d');
        break
    end
end

% skip empty lines
while (~feof(fid)) 
    line = fgetl(fid);
    line_count = line_count + 1;
    if ~isempty(line)
        break
    end
end
    
col_names = textscan(line, '%s');
col_names = col_names{1};

% Infer format string for text scanning
% format_str = '';
%
% for i=1:length(col_names)
%    format_str = strcat(format_str, ' "%f"');
% end

% format string (assuming no of columns is always the same)
format_str = '"%d" "%f" "%d" "%d" "%f"';

% skip empty lines
while (~feof(fid)) 
    line = fgetl(fid);
    line_count = line_count + 1;
    if ~isempty(line)
        break
    end
end

fclose(fid);

t = readtable(filename, 'HeaderLines', line_count - 1, 'Format', format_str, 'ReadVariableNames', false); 
t.Properties.VariableNames = col_names;
t.Properties.UserData.SourceFilename = filename;

end

