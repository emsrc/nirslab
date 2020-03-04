function print_events(events )

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

for key=events.keys
    values = sprintf('%d ', events(key{1}));
    fprintf('%s ==> %s\n', key{1}, values)
end

fprintf('\n')

