function columns = col(data, varargin)
% columns = col(data, 'pat1', 'pat2', ... )
% 
% Retrieve one or more columns from data.sample by matchings
% the combined string patterns against the column labels in data.legenda.
% Returns a cell array for columns. If all returned cell arrays are of the
% same data type, they can can be converted to a matrix with cell2mat().
% The patterns are combined into a single regular expression, so special
% character (e.g. ., (, ), , and ]) have to be escaped.
%
% Examples:
% col(data, 'R1')
% col(data, '308', 'R1', 'T1', 'O2Hb')
% cold(data, '\[308\]')

% weird syntax trick to pass on varargin
selection = colsel(data, varargin{:});
columns = data.samples(selection);

end

