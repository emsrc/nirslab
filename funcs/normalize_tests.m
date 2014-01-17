function norm = normalize_tests(norm, start_marker, mean_interval, varargin)
% norm = normalize_tests(norm, 'start_marker', mean_interval)
% norm = normalize_tests(norm, 'start_marker', mean_interval, systems)
% 
% Normalize test data
%
% Examples:
% normalize_tests(norm, "i", mean_interval)
% normalize_tests(norm, "i", mean_interval, {'nirsO'})


% Default
systems = {'nirsO', 'nirsP'};
if nargin > 3, systems = varargin{1}; end
 
for nirs = systems
    nirs = nirs{1};
    
    for test_n=1:length(norm.(nirs).test)
        test_data = norm.(nirs).test(test_n);
        
        % end of mean interval coincides with start marker
        end_samp = event_samp(test_data, start_marker);
        
        % convert mean interval time from seconds to samples
        mean_samples = mean_interval * test_data.export_sample_rate;
        
        % get start of mean interval, clipping to first sample
        start_samp = max(1, end_samp - mean_samples);
        
        col_numbers = find(colsel(test_data, '(O2Hb|HHb|tHb|HbDiff)'));
        
        for col_n=col_numbers'
            % get mean over interval
            samples = test_data.samples{col_n};
            interval = samples(start_samp:end_samp);
            correction = mean(interval);
            % normalize by subtracting mean from all samples
            samples = samples - correction;
            norm.(nirs).test(test_n).samples{col_n} = samples;
        end
    end
end

end