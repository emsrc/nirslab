function data = set_occlusion_markers(data,...
    start_marker, end_marker, num_occl)
% Automatically set start and end marker for occlusions in cuff signal.
% Markers are saved in event map only, not in events column. 
%
% data = set_occlusion_markers(data, start_marker, end_marker, num_occl)
% 
%   data: struct
%       result from read_oxysoft_output, including events column
%   start_marker: char (string)
%       start of interval marker in events (single letter) 
%   end_marker: char (string)
%       end of interval marker in events (single letter) 
%   num_occl: 
%       number of occlusions 
%
% Warning: old start and end markers in event map will be deleted! 

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

cuffp_signal = colmat(data, 'AD1');
% define delta (half of max-min)
maxcuffp = max(cuffp_signal);
mincuffp = min(cuffp_signal);
delta = (maxcuffp - mincuffp) * 0.5;

if delta == 0;
    error('delta is zero (no signal?)')
end

% peak detection
[maxtab, mintab] = minpeakdet(cuffp_signal, delta);

% get start and end indices (possibly too may/few)
start_idx = mintab(:,1)';
end_idx = maxtab(:,1)';

% spacing between fillers
filler_spacing = round(length(cuffp_signal) / 100);

if length(start_idx) < num_occl
    % not enough start markers detected, add fillers upto num_occl
    start_fill_idx = (1:num_occl - length(start_idx)) * filler_spacing;
    start_idx = [start_fill_idx, start_idx];
elseif length(start_idx) > num_occl
    % too many start markers detected, clip upto num_ocll
    start_idx = start_idx(1:num_occl);
end
   
if length(end_idx) < num_occl
    % not enough end markers detected, add fillers upto num_occl
    end_fill_idx =  ( length(cuffp_signal) - ...
        (num_occl - length(end_idx):-1:1) * filler_spacing );
    end_idx = [end_idx, end_fill_idx];
elseif length(end_idx) > num_occl
    % too many end markers detected, clip upto num_ocll
    end_idx = end_idx(1:num_occl);
end

% update events map
data.events(start_marker) = start_idx;
data.events(end_marker) = end_idx;

end

