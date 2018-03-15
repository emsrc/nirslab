function lines = readlines(filename, n)

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

