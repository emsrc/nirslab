function tt = read_physioflow_tt(filename)

% read_physioflow_output(filename)
%
% Read data exported from Physioflow in csv format
% 
% Returns a timetable object with variable names (i.e. columns) corresponding
% to the columns/fields in the Physioflow data.
% Source filename is stored in t.Properties.UserData.SourceFilename.
% Skipped header lines are stored in t.Properties.UserData.Header

% FIXME: Table header line contains variable names and sometimes units 
% (between brackets), e.g. "CO (l/min)". 
% Should be parsed into names and units.

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

format = ...
   "%{HH:mm:ss}D" + ...     %  1: Elapsed Time
   "%{HH:mm:ss}D" +  ...    %  2: Time
   "%f" + ...               %  3: SV (ml)
   "%f" + ...               %  4: SVi (ml/m<B2>)
   "%d" + ...               %  5: HR (bpm)
   "%f" + ...               %  6: CO (l/min)
   "%f" + ...               %  7: CI (l/min/m<B2>)
   "%d" + ...               %  8: SABP (mmHg)
   "%d" + ...               %  9: DABP (mmHg)
   "%d" + ...               % 10: MABP (mmHg)
   "%s" + ...               % 11: CTI
   "%f" + ...               % 12: VET (ms)
   "%f" + ...               % 13: EDFR (%)
   "%s" + ...               % 14: LCWi (kg.m/m<B2>) 
   "%s" + ...               % 15: SVRi (dyn.s/cm5.m<B2>)
   "%s" + ...               % 16: SVR (dyn.s/cm5)
   "%s" + ...               % 17: EDV est (ml) 
   "%f" + ...               % 18: EF est (%)
   "%d" + ...               % 19: Signal Quality (%)
   "%s";                    % 20: Marks

tt = readtable(filename, 'Format', format, 'TreatAsEmpty', '=na()');

% The colums below contain a comma as a the "thousands separator",
% e.g. "1,556.15", which Matlab does not understand.
% To deal with this, we first read the column as a string (cell array).
% Then we remove the commas and convert to float 
%tt.CTI = str2double(strrep(tt.CTI, ',', ''));
tt.CTI = str2double(tt.CTI);
tt.LCWi_kg_m_m__ = str2double(tt.LCWi_kg_m_m__);
tt.SVR_dyn_s_cm5_ = str2double(tt.SVR_dyn_s_cm5_);
tt.SVRi_dyn_s_cm5_m__ = str2double(tt.SVRi_dyn_s_cm5_m__);
tt.EDVEst_ml_ =  str2double(tt.EDVEst_ml_);

tt.Properties.UserData.SourceFilename = filename;

% read header lines and store (unparsed) in t.Properties.UserData.Header 
opts = detectImportOptions(filename);
tt.Properties.UserData.Header = readlines(filename, opts.VariableNamesLine-1);

% convert datetime to duration in seconds
tt.ElapsedTime = tt.ElapsedTime - tt.ElapsedTime(1);
tt.ElapsedTime.Format = 's';

tt = table2timetable(tt, 'RowTime', 'ElapsedTime');

end

