%==========================================================================
% Example script: how to filter normalized nirs 
%==========================================================================

warning on;

subjects = 3:3;
periods = 1:1;
days = 1:3;

% filename pattern for norm data
norm_file_pat = '~/tmp/data/norm/12ce%03d/12ce%03d_p%d_d%d_norm.mat';

% filename pattern for filtered data
filt_file_pat = '~/tmp/data/filt/12ce%03d/12ce%03d_p%d_d%d_filt.mat';

% define a filter
filter = @(samples) Filtall(samples,' low', 50, [], 0.5, 8, 1);


for s = subjects
    for p = periods
        for d = days  
            % -------------------------------------------------------------
            % 1. load norm data
            % -------------------------------------------------------------
            norm_filename = sprintf(norm_file_pat, s, s, p, d);
            
            if exist(norm_filename, 'file') == 0
                warning('no norm file %s', norm_filename)
                continue
            end
            
            load(norm_filename)
            
            % -------------------------------------------------------------
            % 2. apply filter
            % ------------------------------------------------------------- 
            norm = filter_tests(norm, filter);
            
            % -------------------------------------------------------------
            % 2. save filtered data
            % -------------------------------------------------------------               
            filt_filename = sprintf(filt_file_pat, s, s, p, d);
            
            filt_dir = fileparts(filt_filename);
            if isdir(filt_dir) == 0
                mkdir(filt_dir)
            end
            
            fprintf('saving to filtered data file  %s\n', filt_filename);
            save(filt_filename, 'norm')
        end
    end
end
