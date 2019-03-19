function tt = read_velotron_tt(filename)

% read_velotron_tt(filename)
%
% Read data exported from Velotron as a timetable object
% 
% Returns a timetable object with variable names (i.e. columns) corresponding
% to the to the columns/fields in the Velotron data 


% 'readtable' function cannot cope with spaces included in quoted values,
% so this requires more work...

fid = fopen(filename, 'r');
line_count = 0;
header = cell(100,1);

% skip over [USER DATA] section and read number of records
while (~feof(fid)) 
    line = fgetl(fid);
    line_count = line_count + 1;
    header{line_count} = line;
    if regexp(line, '^number of records')
        % n_records = textscan(line, 'number of records = %d');
        break
    end
end

% skip empty lines
while (~feof(fid)) 
    line = fgetl(fid);
    line_count = line_count + 1;
    header{line_count} = line;
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
    header{line_count} = line;
    if ~isempty(line)
        break
    end
end

fclose(fid);

tt = readtable(filename, 'HeaderLines', line_count - 1, 'Format', format_str, 'ReadVariableNames', false); 
tt.Properties.VariableNames = col_names;
tt.Properties.UserData.SourceFilename = filename;
tt.Properties.UserData.Header = header{1:line_count};

tt = table2timetable(tt, 'RowTime', milliseconds(tt.ms));

end

