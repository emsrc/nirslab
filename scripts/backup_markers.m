%==========================================================================
% Example script: how to backup and restore markers 
%==========================================================================

% action to perform, either
action = 'backup';
%action = 'restore';

subjects = 3:3;
periods = 1:1;
days = 1:3;

% filename pattern for backups 
marker_file_pat = '~/tmp/data/backups/12ce%03d/12ce%03d_p%d_d%d_t%d_markers.mat';

% filename pattern for norm data
norm_file_pat = '~/tmp/data/norm/12ce%03d/12ce%03d_p%d_d%d_norm.mat';

% markers to restore
markers = {'X' 'Y'};

% show warnings but without line numbers
warning('on', 'verbose');
warning('off', 'backtrace')


for s = subjects
    for p = periods
        for d = days   
            fprintf('subject=%d period=%d day=%d\n', s, p, d)
            
            norm_filename = sprintf(norm_file_pat, s, s, p, d);
            
            if exist(norm_filename, 'file') == 0
                warning('no norm file %s', norm_filename)
                continue
            end
            
            fprintf('loading norm data file %s\n', norm_filename)
            load(norm_filename)
                    
            for t=1:length(norm.nirsO.test)          
                marker_filename = sprintf(marker_file_pat, s, s, p, d, t); 
                                
                if strcmp(action,'backup')
                    marker_dir = fileparts(marker_filename);
                    if isdir(marker_dir) == 0
                        mkdir(marker_dir)
                    end
                    backup_events(norm.nirsO.test(t), marker_filename)
                    fprintf('backed up to marker file  %s\n', marker_filename);
                    
                elseif strcmp(action,'restore')                    
                    fprintf('loading marker file  %s\n', marker_filename);
                    restore_events(norm.nirsO.test(t), marker_filename,...
                        markers);   
                else
                    error('unknown action: %s', action)
                end
            end
            
            if strcmp(action,'backup')
                save(norm_filename, 'norm')
                fprintf('restored markers to norm data file %s\n', ...
                    norm_filename);
            end
        end
    end
end
