% example of processing subject data


warning on;

% filename pattern for exported nirs data
nirs_file_pat = '../../data/12ce%03d/12ce%03d_p%dd%d_%s.txt';

% filename pattern for saving subject data
mat_file_pat = '../../data/12ce%03d.mat';

% number of subjects
subjects = 6;

% number of periods
periods = 1;

% number of days
days = 3;

% margins around extracted tests samples (in seconds)
left_margin = 60;
right_margin = 60;

% interval for calculating mean signal while normalizing (in seconds)
mean_interval = 30;

% start and end of test markers
start_marker = 'i';
end_marker = 'j';

% oxymon/portmamon synchronization marker
sync_marker = 'b';

% define a filter
filter = @(samples) Filtall(samples,' low', 50, [], 0.5, 8, 1);


%for s = 6:6
for s = 1:subjects
    % -------------------------------------------------------------
    % 1. read in nirs data
    % -------------------------------------------------------------
    
    % create empty structure for subject data
    subj_data = struct();
    
    for p = 1:periods
%        for d = 2:3
        for d = 1:days
            for nirs = {'nirsO', 'nirsP', 'nirsO_od', 'nirsP_od'}
                filename = sprintf(nirs_file_pat, s, s, p, d, nirs{1});
                
                if exist(filename, 'file') == 0                    
                    warning('no file %s', filename)
                    continue
                end
                    
                fprintf('reading %s\n', filename);
                % store nirs data in path
                % subj_data.period(period).day(day).raw.(nirs)
                subj_data = read_nirs_raw(subj_data, p, d, nirs{1}, ...
                    filename);
            end
        end
    end
    
    % skip processing if we don't have any raw data for this subject
    if ~isfield(subj_data, 'period')
        warning('no data processed for subj=%d', s)
        continue
    end
                        
    fprintf('processing data for subj=%d\n', s)
    
    % -------------------------------------------------------------
    % 2. extract tests
    % -------------------------------------------------------------
    subj_data = extract_oxymon_tests(subj_data, ...
        start_marker,end_marker, ...
        left_margin, right_margin);
    
    subj_data = extract_portamon_tests(subj_data, ...
        sync_marker, start_marker, end_marker, ...
        left_margin, right_margin);
    
    % -------------------------------------------------------------
    % 3. filter selected signals in tests
    % -------------------------------------------------------------
    subj_data = filter_tests(subj_data, filter);
    
    % -------------------------------------------------------------
    % 4. normalize tests
    % -------------------------------------------------------------
    subj_data = normalize_tests(subj_data, start_marker, ...
        mean_interval);
    
    % -------------------------------------------------------------
    % 5. check number of tests
    % -------------------------------------------------------------
    for p=1:periods
        for d=1:days
        
            if ~isfield(subj_data.period(p).day(d).raw, 'nirsO')
                warning('no oxymon tests extracted for period=%d day=%d', ...
                    p, d)
                continue
            end
            if ( ~isfield(subj_data.period(p).day(d).raw, 'nirsO') || ...
                    ~isfield(subj_data.period(p).day(d).raw, 'nirsP') )
                warning('no portamon tests extracted for period=%d day=%d', p, d)
                continue
            end

            if ( d == 1 && ...
                    length(subj_data.period(p).day(d).norm.nirsO.test) ~= 3)
                warning('Day 1 does not contain 3 tests, adjust "I" and "J" markers in OxySoft (nirsO)');
            elseif ( d == 2 && ...
                    length(subj_data.period(p).day(d).norm.nirsO.test) ~= 2)
                warning('Day 2 does not contain 2 tests, adjust "I" and "J" markers in OxySoft (nirsO)');
            elseif (d == 3 && ...
                    length(subj_data.period(p).day(d).norm.nirsO.test) ~= 2)
                warning('Day 3 does not contain 2 tests, adjust "I" and "J" markers in OxySoft (nirsO)');
            end
        end
    end
            
    % -------------------------------------------------------------
    % 6. save
    % -------------------------------------------------------------
    mat_filename = sprintf(mat_file_pat, s);
    fprintf('saving %s\n', mat_filename);
    save(mat_filename, 'subj_data');
    
    % -------------------------------------------------------------
    % 7. plot some examples
    % -------------------------------------------------------------
%     for p=1:length(subj_data.period)
%         for d=1:length(subj_data.period(p).day)
%             for t=1:length(subj_data.period(p).day(d).norm.nirsO.test)
%                 % create new figure for each test
%                 figure('Name', sprintf('Period:%d Day:%d Test:%d',...
%                     p, d, t));
%                 plot_tests( ...
%                     subj_data.period(p).day(d).norm.nirsO.test(t), ...
%                     subj_data.period(p).day(d).norm.nirsP.test(t));
%             end
%         end
%     end
end



