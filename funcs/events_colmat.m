function mat = events_colmat(data, start_marker, end_marker, ...
    start_offset, end_offset, event_n, varargin)
% mat = events_colmat(data, start_marker, end_marker, start_offset,
% end_offset, event_n, 'pat1', 'pat2', ...)
%
% Retrieve one or more columns from data.sample by matchings the combined
% string patterns against the column labels in data.legenda. Rather than
% the whole signal (as in function 'colmat'), the signal is trimmed to n-th
% event interval demarcated by the begin and end markers. The offsets allow
% trimming before (negative offset) or after (positive offset) an event
% marker. Offsets are in samples. Returns a matrix. Therefore, all columns
% must be of the same datatype so they can can be converted to a matrix
% with cell2mat(). That means you must exclude the Events column. The
% patterns are combined into a single regular expression, so special
% character (e.g. ., (, ), [, and ]) have to be escaped  (e.g. \., \(, \),
% \[, and \]).
%
% If the offsets exceed the size of the signal, the matrix is filled out
% with Nan.
%
% Examples:
% events_colmat(data, 'A', 'B', 0, 0, 1, 'R1')
% events_colmat(data, 'A', 'B', -100, 100, 2, '308', 'R1', 'T1', 'O2Hb')
% events_colmat(data, 'A', 'B', 0, 0, 1, '\[308\]')

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

% get start sample of n-th event +/- start offset
samps = event_samp(data, start_marker);
start_marker_samp = samps(event_n);
start_samp = start_marker_samp + start_offset;

% get end sample of n-th event +/- end offset
samps = event_samp(data, end_marker);
end_marker_samp = samps(event_n);
end_samp = end_marker_samp + end_offset;

% weird syntax trick to pass on varargin
mat = colmat(data,  varargin{:});

last_samp = size(mat, 1);

if start_samp < 1
    warning('start_offset (%d samples) is larger than number of samples before the start event marker (%d samples)',...
        -start_offset, start_marker_samp - 1);
    left_filler = nan(-start_offset - start_marker_samp, size(mat,2));
    start_samp = 1;
else
    left_filler = [];
end

if end_samp > last_samp;
    warning('end_offset (%d samples) is larger than number of samples after end event marker (%d samples)',...
        end_offset, last_samp - end_marker_samp);
    right_filler = nan(end_samp - last_samp, size(mat,2));
    end_samp = last_samp;
else
    right_filler = [];
end

% get slice corresponding to event
mat = mat(start_samp:end_samp,:);

% prepend Nans to the left and append Nans to the right
% in case signal is too short for given offsets
mat = cat(1, left_filler, mat, right_filler);

end

