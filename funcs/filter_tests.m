function norm = filter_tests(norm, filter)
% apply filter to selected signals in normalized test samples

for nirs = {'nirsO', 'nirsP'}
    nirs = nirs{1};
    for test_n = 1:length(norm.(nirs).test)
        test_data = norm.(nirs).test(test_n);
        col_numbers = find(colsel(test_data, '(O2Hb|HHb|tHb|HbDiff|TSI$)'));
        
        for col_n=col_numbers'
            norm.(nirs).test(test_n).samples{col_n} = ...
                filter(test_data.samples{col_n});
        end
    end
end

end