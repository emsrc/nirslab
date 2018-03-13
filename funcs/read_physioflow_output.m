function t = read_physioflow_output(filename)

% read_physioflow_output(filename)
%
% Read data exported from Physioflow in txt format
% 
% Returns a table object with variable names (i.e. columns) corresponding
% to the columns/fields in the Biodex data.
% Source filename is stored in t.Properties.UserData.SourceFilename.
% Skipped header lines are stored in t.Properties.UserData.Header

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
   "%f" + ...               % 14: LCWi (kg.m/m<B2>) 
   "%s" + ...               % 15: SVRi (dyn.s/cm5.m<B2>)
   "%s" + ...               % 16: SVR (dyn.s/cm5)
   "%f" + ...               % 17: EDV est (ml) 
   "%f" + ...               % 18: EF est (%)
   "%d" + ...               % 19: Signal Quality (%)
   "%s";                    % 20: Marks

opts = detectImportOptions(filename);
t = readtable(filename, 'Format', format, 'TreatAsEmpty', '=na()');

% The three colums below contain a comma as a the "thousands separator",
% e.g. "1,556.15", which Matlab does not understand.
% To deal with this, we first read teh column as a string (cell array).
% Then we remove the commas and convert to float 
t.CTI = str2double(strrep(t.CTI, ',', ''));
t.SVR_dyn_s_cm5_ = str2double(strrep(t.SVR_dyn_s_cm5_, ',', ''));
t.SVRi_dyn_s_cm5_m__ = str2double(strrep(t.SVRi_dyn_s_cm5_m__, ',', ''));

t.Properties.UserData.SourceFilename = filename;

% read header lines and store (unparsed) in t.Properties.UserData.Header 

fid = fopen(filename);
header = cell(opts.VariableNamesLine-1, 1);

for i=1:opts.VariableNamesLine-1
    header{i} = fgetl(fid);
end    

fclose(fid);

t.Properties.UserData.Header = header;

end



