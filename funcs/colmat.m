function mat = colmat(data, varargin)
% mat = colmat(data, 'pat1', 'pat2', ... )
% 
% Retrieve one or more columns from data.sample by matchings the combined
% string patterns against the column labels in data.legenda. Returns a
% matrix. Therefore, all columns must be of the same datatype so they can
% can be converted to a matrix with cell2mat(). That means you must exclude
% the Events column. The patterns are combined into a single regular
% expression,  so special character (e.g. ., (, ), [, and ]) have to be
% escaped  (e.g. \., \(, \), \[, and \]).
%
% Examples:
% colmat(data, 'R1')
% colmat(data, '308', 'R1', 'T1', 'O2Hb')

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

% colmat(data, '\[308\]')

% weird syntax trick to pass on varargin
mat = cell2mat(col(data, varargin{:}));

end

