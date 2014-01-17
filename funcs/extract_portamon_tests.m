function test_data = extract_portamon_tests(...
    raw_nirso_data, raw_nirsp_data, sync_marker, ...
    start_marker, end_marker, ...
    start_margin, end_margin)
%
% extract samples for tests from portamon samples according to markers
% in the corresponding oxymon data
%
% raw_nirso_data: struct array
%    raw oxymon data for subject
% raw_nirsp_data: struct array
%    raw portamon data for subject
% sync_marker: char
%     synchronization marker occurring in both oxymon and portamon samples
% start_marker: char
%    start marker in oxymon samples
%    (matching is case-insensitive and only on the first character)
% end_marker: char
%    end marker in oxymon samples
%    (matching is case-insensitive and only on the first character)
% start_margin: float
%    start margin, time between start of samples and start marker 
%    in seconds
% end_margin: float 
%    end margin, time between end marker and end of samples 
%    in seconds
%
% test_data: struct array
%    struct with field 'test' containing the data per test 


% maximum time difference allowed between offsets in ms
max_offset = 1000;

raw_nirsp_data = copy_markers(raw_nirso_data, raw_nirsp_data, ...
    sync_marker);

test_data = extract_tests(raw_nirsp_data, start_marker, end_marker,...
    start_margin, end_margin);



    function raw_nirsp_data = copy_markers(raw_nirso_data, ...
            raw_nirsp_data, sync_marker)
        % copy markers from oxymon to portamon data
        null_marker = '0';
         
        % compute mean of offsets over all sync markers (in ms)
        all_offsets = compute_offset(raw_nirso_data, sync_marker, ...
            raw_nirsp_data, sync_marker);
        %all_offsets

        if max(all_offsets) - min(all_offsets) > max_offset
            error('difference between offsets more than max_offset')
        end
        offset = mean(all_offsets);
        
        % get all markers and their times in oxymon
        [all_markers, all_times] = all_events(raw_nirso_data);
        %all_markers
        %all_times
        % convert to portamon times
        all_times = all_times - offset;
        
        % sample duration of portamon (in ms)
        samp_duration = 1000 / raw_nirsp_data.export_sample_rate;
        
        % get nearest sample numbers in portamon 
        nirsp_samp_nums = round(all_times / samp_duration);
        
        % *** FIXME: this should use event map instead of event columns 
        selection = colsel(raw_nirsp_data, 'Event');
        
        % delete all start markers in orginal portamon
        start_mask = strncmpi(start_marker, ...
            raw_nirsp_data.samples{selection} , 1);
        raw_nirsp_data.samples{selection}(start_mask) = {null_marker};
        
        % delete all end markers in orginal portamon
        end_mask = strncmpi(end_marker, ...
            raw_nirsp_data.samples{selection} , 1);
        raw_nirsp_data.samples{selection}(end_mask) = {null_marker};
        
        % copy markers to portamon
        raw_nirsp_data.samples{selection}(nirsp_samp_nums) = all_markers;
    end



    function offsets = compute_offset(data1, marker1, data2, marker2)
        % computes the offset(s) in ms between all occurrences of marker1 in data1
        % and corresponding marker2 in data2
        %
        % data1: struct
        %   result from read_oxysoft_output, including an Event field
        % marker1: string
        %   any marker (matching is case-insensitive)
        % data2: struct
        %   result from read_oxysoft_output, including an Event field
        % marker2: string
        %   any marker (matching is case-insensitive)
        %
        % Normally data1 is oxymon, data2 is portamon, and marker1 and marker2
        % are identical. Number of markers in data1 and data2 must be the same.
        
        % get event times in ms
        event_times1 = event_times(data1, marker1);
        event_times2 = event_times(data2, marker2);
        if length(event_times1) ~= length(event_times2)
            error('Different number of  sync markers: %d in Oxymon data and %d in Portamon',...
                length(event_times1), length(event_times2))
        end
        offsets = event_times1 - event_times2;
    end



    function [markers, times] = all_events(data)
        % return marker and time (in ms) of all events
        %
        % data: struct
        %   result from read_oxysoft_output, including an Event field
        
        no_event = '0';
        % *** FIXME: this should use event map instead of event columns 
        events = col(data, 'Event');
        
        % find sample numbers of events
        samp_nums = find(~strncmpi(no_event, events{1}, 1));
        
        % extract markers
        markers = events{1}(samp_nums);
        
        % determine time of events in ms
        times = (samp_nums / data.export_sample_rate) * 1000;        
    end

end

