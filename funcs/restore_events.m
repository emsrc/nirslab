function data = restore_events(data, filename, markers)

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

load(filename, 'events')

for m = markers
    m = m{1};
    if isKey(events, m)
        data.events(m) = events(m);
    else
        warning('backup contains no marker %s', m)
    end
end

end

