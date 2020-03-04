function markers_tt = tt_markers(tt, event_var)
% return time of markers in variable event_var from timetable tt 

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

     unique_markers = unique(tt{:, event_var});
     most_frequent_marker = unique_markers(1);
     marker_index = ~strcmp(tt{:, event_var}, most_frequent_marker);
     markers_tt = tt(marker_index, {event_var});
end

