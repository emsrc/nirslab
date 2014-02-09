function mat = event_colmat(data, marker, left_offset, right_offset, ...
    event_n, varargin)
% mat = event_colmat(data, marker, left_offset, right_offset, event_n,
% 'pat1', 'pat2', ...)
%
% Retrieve one or more columns from data.sample by matchings the combined
% string patterns against the column labels in data.legenda. Rather than
% the whole signal (as in function 'colmat'), the signal is trimmed to an
% interval around the n-th occurrence of the event marker. The size of the
% interval is determined by a negative left and a positive right offset, in
% samples. Returns a matrix. Therefore, all columns must be of the same
% datatype so they can can be converted to a matrix with cell2mat(). That
% means you must exclude the Events column. The patterns are combined into
% a single regular expression, so special character (e.g. ., (, ), [, and
% ]) have to be escaped  (e.g. \., \(, \), \[, and \]).
%
% Examples:
% event_colmat(data, 'A', 'B', 0, 0, 1, 'R1')
% event_colmat(data, 'A', 'B', -100, 100, 2, '308', 'R1', 'T1', 'O2Hb')
% event_colmat(data, 'A', 'B', 0, 0, 1, '\[308\]')

% get sample of n-th marker event
marker_samples = event_samp(data, marker);
event_n_samp = marker_samples(event_n);

% left offset must be negative
start_samp = event_n_samp + left_offset;
end_samp = event_n_samp + right_offset;

% weird syntax trick to pass on varargin
mat = colmat(data,  varargin{:});

% get slice corresponding to event
mat = mat(start_samp:end_samp,:);

end

