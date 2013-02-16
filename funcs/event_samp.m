function samp_nums = event_samp(data, marker)
% return sample numbers of all events equal to marker 
%
% data: struct
%   result from read_oxysoft_output, including an Event field
% marker: string
%   any marker (matching is only on first character and case-insensitive)

events = col(data, 'Event');
% find sample numbers of events
samp_nums = find(strncmpi(marker, events{1}, 1));