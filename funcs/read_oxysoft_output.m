function data = read_oxysoft_output(filename)

% read_oxysoft_output(filename)
%
% Read Oxymon/Portamon NIRS data exported to file from Oxysoft
% Returns a struct like this:
%
% data = 
% 
%               filename: '../../data/read_nirs_006.txt'
%                 header: {114x1 cell}
%        export_filename: 'C:\Artinis NIRS\NIRS Data\templates\trial_4P'
%            sample_rate: 10
%               duration: 126.1000
%            num_samples: 1261
%                 system: 'portamon'
%     export_sample_rate: 10
%                 legend: {59x1 cell}
%                samples: {1x59 cell}
%               exp_name: 'Trial 4PM'
%               num_cols: 59
%
% Hint: To get a matrix without the first and final columns from data.sample
% (i.e. without sample numbers and events), simply use the following:
% cell2mat(data.samples(2:data.num_cols-1))

fid = fopen(filename,'r');
data.filename = filename;
data.header = {};

while (~feof(fid))
    line = fgetl(fid);
    if regexp(line, '^Legend')
        data.header{length(data.header) + 1, 1} = line;
        read_legend(fid);
        read_samples(fid);
    else
        process_header_line(line);
    end
end

fclose(fid);
get_exp_name();


% nested functions using 'data'


    function read_legend(fid)
        line = fgetl(fid); % skip columns headers
        data.header{length(data.header) + 1, 1} = line;
        data.legend = {};
        
        while (~feof(fid))
            line = fgetl(fid);
            data.header{length(data.header) + 1, 1} = line;
            if strcmp('', line)
                break
            end
            name = regexp(line, '^\d+[ \t]+(?<name>([^\(\)]+\w|.*))', ...
                'tokens', 'once');
            data.legend = [data.legend; name];
        end
        
        data.num_cols = length(data.legend);
    end



    function read_samples(fid)
        % find start of samples
        while (~feof(fid))
            line = fgetl(fid);
            if regexp(line, '(\d+\s+)+\d+$')
                break
            end
        end
        % create format string
        format_str = '';
        
        for col_name = data.legend'
            %if strcmp(col_name, '(Sample number)')
            %    format_str = strcat(format_str, ' %d');
            if strcmp(col_name, '(Event)')
                format_str = strcat(format_str, ' %s');
            else
                format_str = strcat(format_str, ' %f');
            end
        end
        
        % skip remainder of line, because sometimes events occur multiple
        % times (e.g. 'A\tA')
        format_str = strcat(format_str, ' %*[^\n]');
        data.samples = textscan(fid, format_str, 'delimiter', '\t');
        
        % did we get everything?
        expect_num_cells = data.num_samples * data.num_cols;
        actual_num_cells = sum(cellfun(@length , data.samples));
        assert(expect_num_cells == actual_num_cells,...
        'Reading of samples failed: got only %d of %d cells',...
        actual_num_cells, expect_num_cells)
            
    end



    function process_header_line(line)
        % extract some attribute value pairs of interest
        a = regexp(line, '^(?<attrib>[^:]+)\s*:\s*(?<value>.+)\s*$', 'names');
        
        if ~isempty(a)
            switch a.attrib
                case 'Oxysoft export of'
                    data.export_filename = a.value;
                case 'Datafile sample rate'
                    data.sample_rate = cell2mat(textscan(a.value, '%f'));
                case 'Datafile duration'
                    data.duration = cell2mat(textscan(a.value, '%f'));
                case 'Datafile total number of samples'
                    data.num_samples = cell2mat(textscan(a.value, '%f'));
                case 'Export sample rate'
                    data.export_sample_rate = cell2mat(textscan(a.value, '%f'));
                case 'Optode-template'
                    data.system = 'portamon';
                case 'Optode template'
                    data.system = 'oxymon';
            end
        end
        
        % always store header lines
        data.header{length(data.header) + 1, 1} = line;
    end



    function get_exp_name()
        % extract experiment name from one of the column names
        for col_name = data.legend'
            name = regexp(col_name, '^\s*[^(]+.+\((?<name>.+)\)$', 'names');
            if ~isempty(name{1})
                data.exp_name = name{1}.name;
                break
            end
        end
    end

end
