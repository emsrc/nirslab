function tt = read_jaeger_tt(filename)

% read_jaeger_tt(filename)
%
% Read data exported from Jaeger in GDT format
%
% Returns a timetable object with variable names (i.e. columns) corresponding
% to the columns/fields in the Jaeger data.
% Source filename is stored in tt.Properties.UserData.SourceFilename.
% Skipped header lines are stored in tt.Properties.UserData.Header


% Hint: view GDT files from command line with
% iconv -f ISO-8859-1 -t UTF-8 <17hyp001_t2_m2_c1_jaeg.GDT | tr '\r' '\n' | less

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

% FIXME: what is the right windows char encoding?
fid = fopen(filename,'r'); %, 'l', 'ISO-8859-1');

header = {};

% read header
while (~feof(fid))
    line = fgetl(fid);
    
    if regexp(line, '^ Time')
        break
    end
    
    header = [header; line];
end

% read first part of table and save to temp file
part_var_names = textscan(line, '%s');
part_fname = tempname;
part_fid = fopen(part_fname,'w');
part1_line_count = 0;

while (~feof(fid))
    fprintf(part_fid, '%s\n', line);
    part1_line_count = part1_line_count + 1;
    line = fgetl(fid);
    if regexp(line, '^ Time')
        break
    end
end

fclose(part_fid);

% parse first part of table
part1_tt = read_table_part(part_fname, part_var_names);

% read second part of table and save to temp file
part_var_names = textscan(line, '%s');
part_fid = fopen(part_fname,'w');
part2_line_count = 0;

while (~feof(fid))
    fprintf(part_fid, '%s\n', line);
    part2_line_count = part2_line_count + 1;
    
    % if part2 is longer than part1,
    %ignore the junk at the tail
    if part2_line_count == part1_line_count
       line = false;
       break
    end
    line = fgetl(fid);
end

% FIXME: shoud be handled better
% process final line
if line
    fprintf(part_fid, '%s\n', line);
end
    

% clean up
fclose(part_fid);
fclose(fid);

% parse second part of table
part2_tt = read_table_part(part_fname, part_var_names);

% clean up
delete(part_fname)

% concatenate partial timetable horizontally
tt = [part1_tt part2_tt];

% add metadata
tt.Properties.UserData.SourceFilename = filename;
tt.Properties.UserData.Header = header;

end



function part_tt = read_table_part(part_fname, part_var_names)
    part_table = readtable(part_fname,...
        'FileType', 'text',...
        'HeaderLines', 3,...
        'Delimiter', ' ', ...
        'MultipleDelimsAsOne', 1,...
        'TreatAsEmpty', {'-'});
    
    % delete last column
    % FIXME: do in readtable()
    part_table(:, end) = [];

    % mangle variable names in order to get valid Matlab variable names
    part_table.Properties.VariableNames = matlab.lang.makeValidName(part_var_names{1});

    % convert time as string (e.g. '03:10') to duration type (seconds)
    [Y,M,D,H,MN,S]  = datevec(part_table.Time, 'MM:SS');
    part_table.Time = seconds(MN*60+S);

    part_tt = table2timetable(part_table, 'RowTimes', 'Time');
end


