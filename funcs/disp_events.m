function disp_events(subj_data)
% display all markers (keys) and times (values) in event map of subject data

for marker=subj_data.events.keys
    fprintf('%s: ', marker{1});
    values = subj_data.events.values(marker);
    fprintf('%d ', values{1});
    fprintf('\n')
end
