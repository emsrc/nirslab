function data = restore_events(data, filename, markers)

load(filename, 'events')

for m = markers
    data.events(m{1}) = events(m{1});
end

end

