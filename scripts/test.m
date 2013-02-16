% example of processing subject data


% filename pattern for exported nirs data
nirs_file_pat = '../../data/12ce001/12ce%03d_t%dd%d_%s.txt';

% filename pattern for saving subject data
mat_file_pat = '../../data/12ce%03d.mat';

% number of periods
periods = 3;

% number of days
days = 3;

% number of subjects
subjects = 2;

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


% delete me:
% subjects = 1;
% periods = 1;
% days = 1;
% tests = 1;


for s = 1:subjects
    % -------------------------------------------------------------
    % 1. read in nirs data
    % -------------------------------------------------------------
    
    % create empty structure for subject data
    subj_data = struct();
    
    for p = 1:periods
        for d = 1:days
            for nirs = {'nirsO', 'nirsP'} %, 'nirsO_od', 'nirsP_od'}
                filename = sprintf(nirs_file_pat, s, p, d, nirs{1});
                
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
    % 5. save
    % -------------------------------------------------------------
    mat_filename = sprintf(mat_file_pat, s);
    fprintf('saving %s\n', mat_filename);
    save(mat_filename, 'subj_data');
    
    % -------------------------------------------------------------
    % 6. plot some examples
    % -------------------------------------------------------------
    for t=1:3
        % create new figure for each test
        figure('Name', sprintf('Test %d', t));
        plot_tests( ...
            subj_data.period(1).day(1).norm.nirsO.test(t), ...
            subj_data.period(1).day(1).norm.nirsP.test(t));
    end
end


