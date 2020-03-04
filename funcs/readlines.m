function lines = readlines(filename, n)

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

% readlines(filename, n)
%
% Utility function to read first n lines from file.
% Return lines as cell array.

fid = fopen(filename);
lines = cell(n, 1);

for i=1:n
    lines{i} = fgetl(fid);
end    

fclose(fid);

end

