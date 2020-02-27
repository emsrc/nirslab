function tt = edit_interval_markers_tt(tt, signal_names, event_name, start_marker, end_marker, no_marker, label)
% Edit begin and end markers of signal interval in time table
%
% tt = edit_interval_markers_tt(tt, signal_names, event_name, start_marker, end_marker, no_marker, label)
%
%   tt: timetable
%       result from e.g. nirs_to_tt(
%   signal_names: cell array (string)
%       names of variables to plot
%   start_marker: char (string)
%       start of interval marker in events (single letter) 
%   end_marker: char (string)
%       end of interval marker in events (single letter) 
%   no_marker: char (string)
%       no/empty marker for events (single letter) 
%   label: char (string)
%       figure title
%
% Plots signal(s) together with green lines for begin markers and 
% red lines for end markers. Lines can be dragged to new position.
% Markers are updated accordingly in events column of returned timetable.
% Validity of marker sequence is checked prior to return.
%
% Caveats: 
% - number of start markers must equal number of end markers
% - markers must be single characters
% - events must not contain combined markers like 'I G'
% - numbers of event markers (e.g. 'F1', 'G2') will get lost 
% 
% Example:
%
% nirs_dat = load('/Users/work/Dropbox/Shared/Nirs/sync examples/data/norm/17hyp001/17hyp001_t2_m2_c1_norm.mat'); 
% nirs_tt = nirs_to_tt(nirs_dat.norm.nirsO.test(1));
% 
% signal_names = {'x_109_Rx1_Tx1HHb', 'x_303_Rx1_Tx1O2Hb'};
% event_name = 'x_Event_';
% start_marker = 'F';
% end_marker = 'G';
% no_marker = '0';
% label = 'my plot';
% 
% nirs_tt = edit_interval_markers_tt(nirs_tt, signal_names, event_name, start_marker, end_marker, no_marker, label);
% 

events = tt{:, event_name};
start_idx = find(strncmpi(start_marker, events, 1));
end_idx = find(strncmpi(end_marker, events, 1));

assert(length(start_idx) == length(end_idx), ...
    'Unequal number of start (%d) and end (%d) markers', ...
    length(start_idx), length(end_idx))

assert (~isempty(start_idx), 'No markers found') 

signals = tt{:, signal_names};
f = figure;
plot(signals);
xlim([1 height(tt)]);
title(label);

start_handles = draw_marker_lines(start_idx, [0 153/255 76/255]);
end_handles = draw_marker_lines(end_idx, 'red');

% delete old markers 
tt{start_idx, event_name} = {no_marker};
tt{end_idx, event_name} = {no_marker};

% the "close_request" checks markers and updates start_idx and end_idx
set(f,'CloseRequestFcn',@close_request)
valid_markers = false;

% wait until plot is closed with valid marker sequence
while ~valid_markers
    waitfor(f); 
end

% insert updated events
tt{start_idx, event_name} = {start_marker};
tt{end_idx, event_name} = {end_marker};


    function handles = draw_marker_lines(indices, color)    
        handles = [];
        
        for x = indices.'
            lh = line([x,x], ylim, 'color', color, 'LineStyle', ':', 'LineWidth',2);
            draggable(lh, 'h');
            handles = [handles, lh];
        end
    end


    function close_request(src, evnt)
        start_idx = get_indices_from_figure(start_handles);
        end_idx = get_indices_from_figure(end_handles);
        
        % check that all start markers precede their corrsponding 
        % end markers
        end_before_start = all(start_idx < end_idx);
        
        % check that intervals are not overlapping
        shifted_idx = [start_idx(2:end); inf];
        no_overlap = all(shifted_idx > end_idx);
        
        valid_markers = end_before_start && no_overlap;
        
        if valid_markers
            delete(gcf)
        else
            answer = questdlg('The current sequence of markers is not valid! Are you sure you want to quit?', ...
                'Invalid marker sequence', ...
                'Yes','No','No');
            if strcmp(answer, 'Yes')
                delete(gcf)
            end
        end
    end


    function indices = get_indices_from_figure(handles)
        % get indices of markers from line handles
        indices = zeros(length(handles), 1);
        
        for i = 1:length(handles)
            lh = handles(i);
            x = get(lh, 'XData');
            % get nearest index
           indices(i) = round(x(1));
        end
        
        % sort indices because order of line handles 
        % is irrelevant
        indices = sort(indices);
    end

end

