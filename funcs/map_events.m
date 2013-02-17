function [ map ] = map_events(subj_data)
% construct a mapping from event markers (single chars)
% to an array of their indices

events = col(subj_data, 'Event');
events = events{1};

% find markers and their indices
indices = find(~strncmpi('0', events, 1));
markers = events(indices);

% empy map
map = containers.Map;

for i=1:length(indices)
    % marker consists of char and number (e.g. "B1")
    % FIXME: multiple markers? (e.g. "I1 B1")
    marker_char = markers{i}(1);
    
    if ~isKey(map, marker_char)
        % init new array
        map(marker_char) = indices(i);
    else
        % append to array
        map(marker_char) = [map(marker_char) indices(i)];
    end
end

end

