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
% If the offsets exceed the size of the signal, the matrix is filled out
% with Nan.
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

last_samp = size(mat, 1);

if start_samp < 1
    warning('left_offset (%d samples) is larger than number of samples before the event marker (%d samples)',...
        -left_offset, event_n_samp - 1);
    left_filler = nan(-left_offset - event_n_samp, size(mat,2));
    start_samp = 1;
else
    left_filler = [];
end

if end_samp > last_samp;
    warning('right_offset (%d samples) is larger than number of samples after event marker (%d samples)',...
        right_offset, last_samp - event_n_samp);
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

