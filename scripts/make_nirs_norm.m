%==========================================================================
% Example script: how to extract and normalize nirs data per test 
% from raw nirs data files
%==========================================================================

warning on;

subjects = 3:3;
periods = 1:1;
days = 1:3;

% filename pattern for raw data (creaed by make_nirs_raw.m)
raw_file_pat = '~/tmp/data/raw/12ce%03d/12ce%03d_p%d_d%d_raw.mat';

% filename pattern for norm data
norm_file_pat = '~/tmp/data/norm/12ce%03d/12ce%03d_p%d_d%d_norm.mat';

% start and end of test markers
start_marker = 'i';
end_marker = 'j';

% margins around extracted tests samples (in seconds)
start_margin = 60;
end_margin = 60;

% oxymon/portmamon synchronization marker
sync_marker = 'b';

% interval for calculating mean signal while normalizing (in seconds)
mean_interval = 30;


for s = subjects
    for p = periods
        for d = days     
            % -------------------------------------------------------------
            % 1. load raw data
            % -------------------------------------------------------------
            raw_filename = sprintf(raw_file_pat, s, s, p, d);
            
            if exist(raw_filename, 'file') == 0
                warning('no raw file %s', raw_filename)
                continue
            end
            
            fprintf('loading raw data file %s\n', raw_filename);
            load(raw_filename);
                        
            % -------------------------------------------------------------
            % 2. load/create norm data            
            % -------------------------------------------------------------
            norm_filename = sprintf(norm_file_pat, s, s, p, d);
            
            if exist(norm_filename, 'file') == 2
                % update existing norm structure
                fprintf('loading existing norm data file %s\n', ...
                    norm_filename);
                load(norm_filename);
            else
                % create new norm structure 
                norm = struct();
            end            
            
            % -------------------------------------------------------------
            % 3. extract tests          
            % -------------------------------------------------------------            
            norm.nirsO = extract_tests(raw.nirsO,...
                start_marker, end_marker,...
                start_margin, end_margin);
        
            norm.nirsP = extract_portamon_tests(raw.nirsO, raw.nirsP,...
                sync_marker, start_marker, end_marker, ...
                start_margin, end_margin);
            
            % -------------------------------------------------------------
            % 4. normalize tests          
            % -------------------------------------------------------------             
            norm = normalize_tests(norm, start_marker, mean_interval);
            
            % -------------------------------------------------------------
            % 5. save normalized test data
            % -------------------------------------------------------------            
            norm_dir = fileparts(norm_filename);
            if isdir(norm_dir) == 0
                mkdir(norm_dir)
            end
            
            fprintf('saving to norm data file  %s\n', norm_filename);
            save(norm_filename, 'norm')
        end
    end
end
