function print_events(events )

for key=events.keys
    values = sprintf('%d ', events(key{1}));
    fprintf('%s ==> %s\n', key{1}, values)
end

fprintf('\n')

