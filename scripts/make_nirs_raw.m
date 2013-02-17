%==========================================================================
% Example script: how to make raw nirs data files out of 
% text files exported from oxymon software
%==========================================================================

warning on;

subjects = 3:3; % or [2,12]
periods = 1:1;
days = 1:3;
nirs = {'nirsO' 'nirsP' 'nirsO_od' 'nirsP_od'};

% filename pattern for exported nirs data
exp_file_pat = '../../../data/export/12ce%03d/12ce%03d_p%dd%d_%s.txt';

% filename pattern for raw data
raw_file_pat = '~/tmp/data/raw/12ce%03d/12ce%03d_p%d_d%d_raw.mat';

for s = subjects
    for p = periods
        for d = days               
            % -------------------------------------------------------------
            % 1. load/create raw data
            % -------------------------------------------------------------
            raw_filename = sprintf(raw_file_pat, s, s, p, d);
            
            if exist(raw_filename, 'file') == 2
                % update existing raw structure
                fprintf('loading existing raw data file %s\n', raw_filename);
                load(raw_filename);
            else
                % create new raw structure 
                raw = struct();
            end
            
            % -------------------------------------------------------------
            % 2. parse exported data
            % -------------------------------------------------------------
            for n = nirs
                n = n{1};
                exp_filename = sprintf(exp_file_pat, s, s, p, d, n);
                
                if exist(exp_filename, 'file') == 0                    
                    warning('no export file %s', exp_filename)
                    continue
                end                
                
                fprintf('reading export file %s\n', exp_filename);
                raw.(n) = read_oxysoft_output(exp_filename);
            end
            
            % -------------------------------------------------------------
            % 3. save raw data
            % -------------------------------------------------------------
            raw_dir = fileparts(raw_filename);
            if isdir(raw_dir) == 0
                mkdir(raw_dir)
            end
            
            fprintf('saving to raw data file  %s\n', raw_filename);
            save(raw_filename, 'raw')
        end
    end
end