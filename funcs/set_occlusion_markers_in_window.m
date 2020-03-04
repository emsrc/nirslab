function data = set_occlusion_markers_in_window(data,...
    window_start_marker, window_end_marker,...
    occl_start_marker, occl_end_marker,... 
    num_occl, occl_time, findpeaks_func)
% Automatically set start and end markers for occlusions in cuff signal
% within every marked window.
% Duration of occlusions is fixed.
% Markers are saved in event map only, not in events column. 
%
% data = set_occlusion_markers(data,  
%            window_start_marker, window_end_marker,...
%            occl_start_marker, occl_end_marker,... 
%            num_occl, occl_time, findpeaks_func)
% 
%   data: struct
%       result from read_oxysoft_output, including events map
%   window_start_marker: char (string)
%       event marker (single letter) for start of window 
%   window_end_marker: char (string)
%       event marker (single letter) for end of window
%   occl_start_marker: char (string)
%       event marker (single letter) for start of occlusion 
%   occl_end_marker: char (string)
%       event marker (single letter) for start of occlusion
%   num_occl: double
%       number of occlusions 
%   occl_time: double
%       duration of each occlusion in seconds
%   findpeaks_func: function handle
%       handle for findpeaks function that takes a signal 
%       (a row or column vector with real-valued elements) as input
%       and returns [peaks, indices]
%
% Example of how to define a findpeaks_func:
% 
% myfindpeaks = @(signal) findpeaks(signal,...
%                                   'MINPEAKDISTANCE', 50,...
%                                   'NPEAK', num_occl, ...
%                                   'SORTSTR', 'desc');

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

win_start_indices = data.events(window_start_marker);
win_end_indices = data.events(window_end_marker);

cuffp_signal = colmat(data, 'AD1');

occl_sample_size = occl_time * data.export_sample_rate; 

% see http://stackoverflow.com/questions/3627107/how-can-i-index-a-matlab-array-returned-by-a-function-without-first-assigning-it
paren = @(x, varargin) x(varargin{:});

    
for win_num=1:length(win_start_indices) 
    win_start_idx =  paren(win_start_indices, win_num);
    win_end_idx = paren(win_end_indices, win_num);
    
    cuffp_signal_window = cuffp_signal(win_start_idx: win_end_idx);
    
    [~, start_indices] = findpeaks_func(cuffp_signal_window);
    start_indices = start_indices';
        
    % spacing between fillers
    filler_spacing = round(length(cuffp_signal_window) / 100);
    
    if length(start_indices) < num_occl
        % not enough start markers detected, add fillers upto num_occl
        fill_indices = (1:num_occl - length(start_indices)) * filler_spacing;
        start_indices = [fill_indices, start_indices];
    elseif length(start_indices) > num_occl
        % too many start markers detected, clip upto num_ocll
        start_indices = start_indices(1:num_occl);
    end
    
    % correct for window
    start_indices = start_indices + win_start_idx - 1 ;
    
    % end indices have fixed distance from start indices
    end_indices = start_indices + occl_sample_size;
    
    % update events map
    if isKey(data.events, occl_start_marker)
        data.events(occl_start_marker) = [data.events(occl_start_marker), start_indices];
    else
        data.events(occl_start_marker) = start_indices;
    end
    
    if isKey(data.events, occl_end_marker)
        data.events(occl_end_marker) = [data.events(occl_end_marker), end_indices];
    else
        data.events(occl_end_marker) = end_indices;
    end
end

data.events(occl_start_marker) = sort(data.events(occl_start_marker));
data.events(occl_end_marker) = sort(data.events(occl_end_marker));

end


