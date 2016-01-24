function ts = edit_interval_markers_ts(ts, start_marker, end_marker, label)
% Edit begin and end markers of time serie 
% 
% data = edit_interval_markers_ts(ts, start_marker, end_marker, label)
%
%   ts: timeseries object
%       any timeseries object with marked events
%   start_marker: char (string)
%       start of interval marker in events (single letter) 
%   end_marker: char (string)
%       end of interval marker in events (single letter) 
%   label: char (string)
%       figure title
%
% Plots signal(s) together with green lines for begin markers and 
% red lines for end markers. Lines can be dragged to new position.
% Markers are updated accordingly in events of returned data.
% Validity of marker sequence is checked prior to return.
%
% Caveats: 
% - number of start markers must equal number of end markers

% get times of start and end markers and remove events from timeseries
% (events are removed because there seems to be no way to avoid plotting
% them)
[start_times, end_times] = get_event_times(start_marker, end_marker);

assert(length(start_times) == length(end_times), ...
    'Unequal number of start (%d) and end (%d) markers', ...
    length(start_times), length(end_times))

assert (~isempty(start_times), 'No markers found') 

f = figure;
plot(ts);
title(label);

start_handles = draw_event_lines(start_times, 'green');
end_handles = draw_event_lines(end_times, 'red');

% the "close_request" checks markers and updates start_idx and end_idx
set(f,'CloseRequestFcn',@close_request)
valid_markers = false;

% wait until plot is closed with valid marker sequence
while ~valid_markers
    waitfor(f); 
end

% add updated events to timeseries
set_events(start_marker, transpose(start_times));
set_events(end_marker, transpose(end_times));

    
    function [start_times, end_times] = get_event_times(start_marker, end_marker)
        start_times = [];
        end_times = [];
        
        for event=ts.Events
            if event.Name == start_marker
                start_times = [start_times, event.Time];
                ts = ts.delevent(start_marker);
            elseif event.Name == end_marker
                end_times = [end_times, event.Time];
                ts = ts.delevent(end_marker);
            end
        end
    end

    function set_events(marker, times)
        for t=times
            ts = ts.addevent(marker, t);
        end
    end


    function handles = draw_event_lines(times, color)    
        handles = [];
        
        for t = times
            lh = line([t,t], ylim, 'color', color, 'LineStyle', '--');
            draggable(lh, 'h');
            handles = [handles, lh];
        end
    end


    function close_request(src, evnt)
        start_times = get_times_from_figure(start_handles);
        end_times = get_times_from_figure(end_handles);
        
        % check that all start markers precede their corrsponding 
        % end markers
        end_before_start = all(start_times < end_times);
        
        % check that intervals are not overlapping
        shifted_idx = [start_times(2:end); inf];
        no_overlap = all(shifted_idx > end_times);
        
        valid_markers = end_before_start && no_overlap;
        
        if valid_markers
            delete(gcf)
        else
            errordlg('Invalid marker sequence! Try again...');
        end
    end


    function times = get_times_from_figure(handles)
        % get indices of markers from line handles
        times = zeros(length(handles), 1);
        
        for i = 1:length(handles)
            lh = handles(i);
            x = get(lh, 'XData');
            % get nearest index
           times(i) = round(x(1));
        end
        
        % sort indices because order of line handles 
        % is irrelevant
        times = sort(times);
    end
        
end


