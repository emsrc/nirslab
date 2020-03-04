function backup_events(data, filename)

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

events = data.events;
save(filename, 'events')
end

