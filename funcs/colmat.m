function mat = colmat(data, varargin)
% columns = colmat(data, 'pat1', 'pat2', ... )
% 
% Retrieve one or more columns from data.sample by matchings
% the combined string patterns against the column labels in data.legenda.
% Returns a matrix. Therefore, all columns must be of the same datatype
% so they can can be converted to a matrix with cell2mat().
% That means you must exclude the Events column.
% The patterns are combined into a single regular expression, so special
% character (e.g. ., (, ), , and ]) have to be escaped.
%
% Examples:
% col(data, 'R1')
% col(data, '308', 'R1', 'T1', 'O2Hb')
% cold(data, '\[308\]')

% weird syntax trick to pass on varargin
mat = cell2mat(col(data, varargin{:}));

end

