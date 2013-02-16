function selection = colsel(data, varargin)
% columns = colsel(data, 'pat1', 'pat2', ... )
% 
% Retrieve indices of one or more columns from data.sample by matchings
% the combined string patterns against the column labels in data.legenda.
% The patterns are combined into a single regular expression, so special
% character (e.g. ., (, ), , and ]) have to be escaped.
% Returns a logical array with 1 for matching columns 0 otherwise.
% Indices can be obtained through find(colsel(...))).
%
% Examples:
% col(data, 'R1')
% col(data, '308', 'R1', 'T1', 'O2Hb')
% cold(data, '\[308\]')

pattern = '.*';

for subpat = varargin
    pattern = strcat(pattern, '.*', subpat);
end

selection = ~cellfun(@isempty, regexp(data.legend, pattern));

end
