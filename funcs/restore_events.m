function data = restore_events(data, filename, markers)

load(filename, 'events')

for m = markers
    m = m{1};
    if isKey(data.events, m)
        data.events(m) = events(m);
    else
        warning('backup contains no marker %s', m)
    end
end

end

