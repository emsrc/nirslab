function disp_events(subj_data)
% display all markers (keys) and times (values) in event map of subject data

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

for marker=subj_data.events.keys
    fprintf('%s: ', marker{1});
    values = subj_data.events.values(marker);
    fprintf('%d ', values{1});
    fprintf('\n')
end
