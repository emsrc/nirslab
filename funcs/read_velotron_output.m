function [ col_names, samples ] = read_velotron_output(filename)

% read_velotron_output(filename)
%
% Read data exported from Velotron
% 
% Returns (1) a cell array of columns names (2) a matrix of samples of
% size n_samples x n_columns

fid = fopen(filename, 'r');

% skip over [USER DATA] section and read number of records
while (~feof(fid)) 
    line = fgetl(fid);
    if regexp(line, '^number of records')
        % n_records = textscan(line, 'number of records = %d');
        break
    end
end

% skip 5 newlines and read columns headers
for i=1:6
    line = fgetl(fid);
end
    
col_names = textscan(line, '%s');
col_names = col_names{1};

% skip 5 newlines until line before start of samples
for i=1:5
    fgetl(fid);
end

% construct format string for text scanning
format_str = '';

for i=1:length(col_names)
    format_str = strcat(format_str, ' "%f"');
end

% read samples
samples = cell2mat(textscan(fid, format_str, 'Delimiter', ','));

fclose(fid);

end

