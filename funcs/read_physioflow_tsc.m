function tsc = read_physioflow_tsc(filename)

% read_physioflow_tsc(filename)
%
% Read data exported from Physioflow as time series collection
% 
% Returns a time series collection where members are time series
% corresponding to the columns/fields in the Physioflow data.
% Source filename is stored in tsc.Name.
% Skipped header lines are stored in tsc.TimeInfo.UserData.Header.


t = read_physioflow_output(filename);

% convert ElapsedTime from HH:mm:ss to miliseconds
ms = milliseconds(t.ElapsedTime - t.ElapsedTime(1));

tsc = tscollection(ms, 'Name', t.Properties.UserData.SourceFilename);
tsc.TimeInfo.Units = 'milliseconds';

for var=t.Properties.VariableNames(2:end)
    var = var{1};
    ts = timeseries(t(:,var), ms, 'Name', var);
    ts.TimeInfo.Units = 'milliseconds';
    tsc = addts(tsc, ts);
end

tsc.TimeInfo.UserData.Header = t.Properties.UserData.Header;

end

