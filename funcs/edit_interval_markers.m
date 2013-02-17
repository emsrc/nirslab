function data = edit_interval_markers(data, signal_pat, ...
    start_marker, end_marker, label)
% Edit begin and end markers of signal interval
% 
% data = edit_interval_markers(data, signal_pat, start_marker, end_marker)
%
%   data: struct
%       result from read_oxysoft_output, including events column
%   signal_pat: char (string)
%       pattern used for matching signal(s) in the legenda
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
% - only changes events map, not events column
% - number of start markers must equal number of end markers
% - markers must be single characters
% - events must not contain combined markers like 'I G'

% get start and end indices of markers 
start_idx = data.events(start_marker);
end_idx = data.events(end_marker);

assert(length(start_idx) == length(end_idx), ...
    'Unequal number of start (%d) and end (%d) markers', ...
    length(start_idx), length(end_idx))

assert (~isempty(start_idx), 'No markers found') 

signal = colmat(data, signal_pat);
f = figure;
plot(signal);
title(label);

start_handles = draw_marker_lines(start_idx, 'green');
end_handles = draw_marker_lines(end_idx, 'red');

% the "close_request" checks markers and updates start_idx and end_idx
set(f,'CloseRequestFcn',@close_request)
valid_markers = false;

% wait until plot is closed with valid marker sequence
while ~valid_markers
    waitfor(f); 
end

% update test data
data.events(start_marker) = start_idx';
data.events(end_marker) = end_idx';



    function handles = draw_marker_lines(indices, color)    
        handles = [];
        
        for x = indices'
            lh = line([x,x], ylim, 'color', color, 'LineStyle', '--');
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
            errordlg('Invalid marker sequence! Try again...');
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


