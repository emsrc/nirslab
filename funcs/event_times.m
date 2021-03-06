function times = event_times(data, marker)
% return time in ms of all events equal to marker
%
% data: struct
%   result from read_oxysoft_output, including an Event field
% marker: string
%   any marker (matching is case-insensitive)

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

% find sample numbers of events
samp_nums = event_samp(data, marker);

% determine time of events in ms
times = (samp_nums / data.export_sample_rate) * 1000;

end
