function subj = extract_oxymon_tests(subj, start_marker, end_marker,...
    start_margin, end_margin)
%
% extract samples for tests from oxymon samples according to markers
%
% subj: struct array
%    subject data
% start_marker: char
%    start marker consisting of a single char 
%    (matching is case-insensitive and only on the first character)
% end_marker: char
%    end marker consisting of a single char 
%    (matching is case-insensitive and only on the first character)
% start_margin: float
%    start margin, time between start of samples and start marker 
%    in seconds
% end_margin: float 
%    end margin, time between end marker and end of samples 
%    in seconds

for period_n = 1:length(subj.period)
    for day_n = 1:length(subj.period(period_n).day)        
        if ~isfield(subj.period(period_n).day(day_n).raw, 'nirsO')
            warning('no oxymon tests extracted for period=%d day=%d', ...
                period_n, day_n)
            continue
        end
        
        % lazy copy for reading only
        raw_data = subj.period(period_n).day(day_n).raw.nirsO;
        norm_data = extract_tests(raw_data, start_marker, end_marker,...
            start_margin, end_margin);
        subj.period(period_n).day(day_n).norm.nirsO = norm_data;        
    end
end

end

