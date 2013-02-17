%==========================================================================
% Example script: auto set, edit and save occlusion markers 
%==========================================================================

warning on;

subjects = 3:3;
periods = 1:1;
days = 1:1;

% filename pattern for norm data
norm_file_pat = '~/tmp/data/norm/12ce%03d/12ce%03d_p%d_d%d_norm.mat';

set_auto = 1;
edit_markers = 1;

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
            
            for t=1:length(norm.nirsO.test)
                
                %-----------------------------
                % Define number of occlusions
                %-----------------------------
                if d == 1
                    if t == 1
                        num_occl = 3;
                    elseif t == 2
                        num_occl = 11;
                    elseif t == 3
                        %num_occl = 0;
                        continue
                    end
                end
                if d == 2
                    if t == 1
                        num_occl = 10;
                    elseif t == 2
                        num_occl = 6;
                    end
                end
                if d == 3
                    if t == 1
                        num_occl = 4;
                    elseif t == 2
                        num_occl = 10;
                    end
                end

                % -------------------------------------------------------------
                % 2. auto set markers
                % ------------------------------------------------------------- 
                
                if set_auto
                    norm.nirsO.test(t) = set_occlusion_markers(...
                        norm.nirsO.test(t), 'X', 'Y', num_occl);
                end
            
                % -------------------------------------------------------------
                % 3. edit markers
                % ------------------------------------------------------------- 
                if edit_markers
                    norm.nirsO.test(t) = edit_interval_markers(...
                        norm.nirsO.test(t), 'AD1', 'X', 'Y', 'blah');
                end
            end
            
            % -------------------------------------------------------------
            % 4. save norm data
            % -------------------------------------------------------------  
            fprintf('saving to norm data file  %s\n', norm_filename);
            save(norm_filename, 'norm')
        end
    end
end
