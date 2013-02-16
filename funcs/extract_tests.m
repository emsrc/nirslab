function  norm_data = extract_tests(raw_data, ...
    start_marker, end_marker, start_margin, end_margin)

% extract samples for tests from oxymon/portamon samples according 
% to start and end markers
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

num_cols = raw_data.num_cols;
    
% convert margin in seconds to margin in samples
start_margin = start_margin * raw_data.export_sample_rate;
end_margin = end_margin * raw_data.export_sample_rate;

start_samp = event_samp(raw_data, start_marker);
end_samp= event_samp(raw_data, end_marker);

assert(length(start_samp) == length(end_samp), ...
    'error: found %d start markers (%s) and %d end markers (%s) in %s', ...
    length(start_samp), start_marker, length(end_samp), end_marker, ...
    raw_data.filename)

assert(all(start_samp < end_samp), ...
    'error: start markers (%s) and end markers (%s) messed up in %s', ...
     start_marker, end_marker, raw_data.filename)

% get start and end sample numbers,
% clipping to first and final sample
start_samp = max(1,...
    event_samp(raw_data, start_marker) - start_margin);
end_samp = min(double(raw_data.num_samples),...
    event_samp(raw_data, end_marker) + end_margin);

% store sample slice for each test
for t=1:size(start_samp,1)
    range = start_samp(t):end_samp(t);
    % allocate cell struct
    test_data.samples = cell(1, num_cols);
    
    % slice each sampled signal (column)
    for i=1:num_cols
        test_data.samples{i} = raw_data.samples{i}(range);
    end
    
    % copy legend etc too, so we can use col(), event_samp(), etc.
    test_data.legend = raw_data.legend;
    test_data.export_sample_rate = raw_data.export_sample_rate;
    test_data.num_cols = num_cols;
    test_data.num_samples = length(test_data.samples{1});
    
    norm_data.test(t) = test_data;
end

end

