function print_events_tt(tt, event_name)

% print_events(tt, events_var)
% 
%   tt: timetable
%       result from e.g. nirs_to_tt()
%   event_name: char (string)
%       name of variable containing the events
%
% Example:
%   print_events(tt, 'x_Event_')

%TODO
% name of events var should be part of of tt properties

 tt(~strncmpi('0', tt.(event_name), 1), event_name)

