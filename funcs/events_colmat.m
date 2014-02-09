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
% Examples:
% events_colmat(data, 'A', 'B', 0, 0, 1, 'R1')
% events_colmat(data, 'A', 'B', -100, 100, 2, '308', 'R1', 'T1', 'O2Hb')
% events_colmat(data, 'A', 'B', 0, 0, 1, '\[308\]')

% get start sample of n-th event +/- start offset
samps = event_samp(data, start_marker);
start_samp = samps(event_n) + start_offset;

% get end sample of n-th event +/- start offset
samps = event_samp(data, end_marker);
end_samp = samps(event_n) + end_offset;

% weird syntax trick to pass on varargin
mat = colmat(data,  varargin{:});

% get slice corresponding to event
mat = mat(start_samp:end_samp,:);

end

