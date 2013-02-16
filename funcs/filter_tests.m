function subj = filter_tests(subj, filter)
% apply filter to selected signals in normalized test samples

for period_n = 1:length(subj.period)
    for day_n = 1:length(subj.period(period_n))
            
        if ~isfield(subj.period(period_n).day(day_n).raw, 'nirsO')
            warning('no oxymon filtering for period=%d day=%d', ...
                period_n, day_n)
            continue
        end
        if ( ~isfield(subj.period(period_n).day(day_n).raw, 'nirsO') || ...
                ~isfield(subj.period(period_n).day(day_n).raw, 'nirsP') )
            warning('no portamon filtering for period=%d day=%d', period_n, day_n)
            continue
        end
        
        for nirs = {'nirsO', 'nirsP'}
            for test_n=1:length(subj.period(period_n).day(day_n).norm.(nirs{1}).test)
                test_data = subj.period(period_n).day(day_n).norm.(nirs{1}).test(test_n);
                col_numbers = find(colsel(test_data, '(O2Hb|HHb|tHb|HbDiff)'));
                
                for col_n=col_numbers'
                    subj.period(period_n).day(day_n).norm.(nirs{1}).test(test_n).samples{col_n} = ...
                        filter(test_data.samples{col_n});
                end
            end
        end
    end
end

end