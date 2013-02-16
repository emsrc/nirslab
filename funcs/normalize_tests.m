function subj = normalize_tests(subj, start_marker, mean_time)

for period_n = 1:length(subj.period)
    for day_n = 1:length(subj.period(period_n))
        
        if ~isfield(subj.period(period_n).day(day_n).raw, 'nirsO')
            warning('no oxymon normalization for period=%d day=%d', ...
                period_n, day_n)
            continue
        end
        if ( ~isfield(subj.period(period_n).day(day_n).raw, 'nirsO') || ...
                ~isfield(subj.period(period_n).day(day_n).raw, 'nirsP') )
            warning('no portamon normalization for period=%d day=%d', period_n, day_n)
            continue
        end

        for nirs = {'nirsO', 'nirsP'}
            for test_n=1:length(subj.period(period_n).day(day_n).norm.(nirs{1}).test)
                test_data = subj.period(period_n).day(day_n).norm.(nirs{1}).test(test_n);
                
                % end of mean interval coincides with start marker
                end_samp = event_samp(test_data, start_marker);
                
                % convert mean interval time from seconds to samples
                mean_samples = mean_time * ...
                    subj.period(period_n).day(day_n).raw.(nirs{1}).export_sample_rate;
                
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
                    subj.period(period_n).day(day_n).norm.(nirs{1}).test(test_n).samples{col_n} = samples;
                end
            end
        end
    end
end

end