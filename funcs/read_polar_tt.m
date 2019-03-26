function polar_tt = read_polar_tt(filename, marker, tolerance)

% read_polar_tt(filename, marker, tolerance)
%
%
% read data exported from Polar and converted to Excel format
%
% filename:     'char'
%               file with Polar data
% marker:       'char'
%               marker to use for laptime events (e.g. 'X')
% tolerance:    seconds
%               tolerance allowed for in mapping laptimes to
%               HR times (e.g. seconds(1:5) )
% 
% Returns a timetable object with variable names (i.e. columns) 
% 'HRBpm' and 'Event', where events are the laptimes from the second sheet. 
% Source filename is stored in tt.Properties.UserData.SourceFilename.


% read polar HR from first sheet
polar_tt = readtable(filename, 'Sheet', 1, 'Range', 'A:B');

% readtable reads Time column in format HH:MM:SS as a double,
% so convert to duration (seconds)
[Y,M,D,H,MN,S] = datevec(polar_tt.Time);
polar_tt.Time = seconds(MN*60+S);

polar_tt = table2timetable(polar_tt);
polar_tt.Properties.UserData.SourceFilename = filename;

% read lap times from second sheet
events_tt = readtable(filename, 'sheet', 2);

% convert to seconds (as above)
[Y,M,D,H,MN,S] = datevec(events_tt.Time);
events_tt.Time = seconds(MN*60+S);

events_tt = table2timetable(events_tt);

polar_tt.Event = repmat({''},height(polar_tt),1);

for exact_time=events_tt.Time'
    for tol=tolerance
        tt = polar_tt(withtol(exact_time, tol), :);
        
        if ~isempty(tt)
            approx_time = tt.Properties.RowTimes(1);
            polar_tt(approx_time, 'Event') = {marker};
            break
        end
    end
    
    if isempty(tt)
        warning('cannot create lap events within given tolerance');
    end
end

end

