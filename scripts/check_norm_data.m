%==========================================================================
% Example script: how to check nirs data 
%==========================================================================

% show warnings but without line numbers
warning('on', 'verbose');
warning('off', 'backtrace')

subjects = 3:4;
periods = 1:1;
days = 1:3;

% filename pattern for raw data (creaed by make_nirs_raw.m)
raw_file_pat = '~/tmp/data/raw/12ce%03d/12ce%03d_p%d_d%d_raw.mat';

% filename pattern for norm data
norm_file_pat = '~/tmp/data/norm/12ce%03d/12ce%03d_p%d_d%d_norm.mat';


for s = subjects
    for p = periods
        for d = days  
            fprintf('Checking subject=%d period=%d day=%d\n', s, p, d)
            
            %--------------------------------------------------------------
            % check raw data
            %--------------------------------------------------------------            
            raw_filename = sprintf(raw_file_pat, s, s, p, d);
            
            if exist(raw_filename, 'file') == 0
                warning('no raw file %s', raw_filename)
            else
                load(raw_filename);
                
                if ~isfield(raw, 'nirsO')
                    warning('no raw oxymon data')
                end
                if ~isfield(raw, 'nirsP')
                    warning('no raw portamon data')
                end
            end
            
            %--------------------------------------------------------------
            % check normalized test data
            %--------------------------------------------------------------
            norm_filename = sprintf(norm_file_pat, s, s, p, d);
            
            if exist(norm_filename, 'file') == 0
                warning('no norm file %s', norm_filename)
            else
                load(norm_filename)
                
                if ~isfield(norm, 'nirsO')
                    warning('no normalized oxymon data')
                    if ~isfield(norm.nirsO, 'test')                         
                        if ( d == 1 && length(norm.nirsO.test) ~= 3)
                            warning('Day 1 does not contain 3 tests, adjust "I" and "J" markers in OxySoft (nirsO)');
                        elseif ( d == 2 && length(norm.nirsO.test) ~= 2)
                            warning('Day 2 does not contain 2 tests, adjust "I" and "J" markers in OxySoft (nirsO)');
                        elseif (d == 3 && length(norm.nirsO.test) ~= 2)
                            warning('Day 3 does not contain 2 tests, adjust "I" and "J" markers in OxySoft (nirsO)');
                        end                        
                    end
                end
                
                if ~isfield(norm, 'nirsP')
                    warning('no normalized portamon data')
                end
            end
        end
    end
end
