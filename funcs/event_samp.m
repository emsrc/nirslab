function samp_nums = event_samp(data, marker)
% return sample numbers of all events equal to marker 
%
% data: struct
%   result from read_oxysoft_output, including an Event field
% marker: string
%   any marker (matching is only on first character and case-insensitive)

%%% Old method:
% events = col(data, 'Event');
%%% find sample numbers of events
% samp_nums = find(strncmpi(marker, events{1}, 1));

% The new method gets the markers from the event table in the raw data,
% which allows setting start & end markers in the raw file before 
% normalisation.

if data.events.isKey(lower(marker))
    samp_nums = data.events(lower(marker))';
else
    samp_nums = data.events(upper(marker))';
end