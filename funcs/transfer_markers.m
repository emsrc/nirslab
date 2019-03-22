function to_tt = transfer_markers(from_tt, to_tt, ...
    from_event_var, to_event_var,...
    from_sync_marker, to_sync_marker, ...
    trans_markers, tolerance)
% Transfer one or more event markers from a source to a target timetable.
%
% to_tt = transfer_markers(from_tt, to_tt, ...
%                      from_event_var, to_event_var,...
%                      from_sync_marker, to_sync_marker, ...
%                      trans_markers, tolerance)
%
%   from_tt:            timetable
%                       source timetable to transfer markers from
%   to_tt:              timetable
%                       target timetable to transfer marker to   
%   from_event_var:     char array
%                       variable (i.e. column name) in source table
%                       containing the markers 
%   to_event_var:       char array
%                       variable (i.e. column name) in target table
%                       that will hold the markers; if it does not exists,
%                       it will be created
%   from_sync_marker:   char
%                       synchronization marker (single letter) in the
%                       source timetable
%   to_sync_marker:     char | false
%                       synchronization marker (single letter) in the
%                       target timetable; if it is false or '', 
%                       synchronization will be carried out to the start 
%                       start of the target signal
%   trans_markers:      char array
%                       one or more markers to be transferred from the
%                       source to the target timetable
%   tolerance:          double
%                       time tolerance in seconds allowed when mapping
%                       source to target times; cf. withtol() function 


% if not present, add new variable to target table for markers
if ~any(strcmp(to_tt.Properties.VariableNames, to_event_var))
    to_tt{:, to_event_var} = {''};
end

% find time of sync marker in source table
from_events = from_tt{:, from_event_var};
samp_num = find(strncmpi(from_sync_marker, from_events, 1));
from_sync_marker_time = from_tt.Properties.RowTimes(samp_num);

if to_sync_marker
    to_events = to_tt{:, to_event_var};
    samp_num = find(strncmpi(to_sync_marker, to_events, 1));
    to_sync_marker_time = to_tt.Properties.RowTimes(samp_num);
else
    % if no target sync marker is given,
    % sync to start of signal
    to_sync_marker_time = to_tt.Properties.RowTimes(1);
end

time_delta = from_sync_marker_time - to_sync_marker_time;

for marker=trans_markers
    % find times of marker in source table
    samp_num = find(strncmpi(marker, from_events, 1));
    from_marker_times = from_tt.Properties.RowTimes(samp_num);
    
    % sync target times to source times
    to_marker_times = (from_marker_times - time_delta)';
    
    % Insert markers in target timetable:
    % The problem here is that the withtol() function can return 
    % multiple matches if the exact time searched for is right in between 
    % two times available in the target table.
    % Therefore, a solution like:
    %   to_tt(withtol(to_marker_times, tolerance), {to_event_var}) = {marker};
    % could actually insert a sequence of two or more markers!
    % Hence the horribly convoluted piece of code below, which gets the 
    % *first* matching row value (i.e. a duration) returned by withtol() 
    for exact_time=to_marker_times
        for tol=tolerance
            % horribly convoluted way to get the first matching row value 
            % (i.e. a duration) returned by withtol()
            tt = to_tt(withtol(exact_time, tol), :);
            
            if ~isempty(tt)
                approx_time = tt.Properties.RowTimes(1);
                to_tt(approx_time, {to_event_var}) = {marker};
                break
            end
        end
        
        if isempty(tt)
            warning('cannot transfer marker %s with given tolerance', marker);
        end
    end
end

end

