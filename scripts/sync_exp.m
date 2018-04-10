
% read nirs timetable
nirs_dat = load('/Users/work/Dropbox/Shared/Nirs/sync examples/data/norm/17hyp001/17hyp001_t2_m2_c1_norm.mat'); 
nirs_tt = nirs_to_tt(nirs_dat.norm.nirsO.test(1));

% find time of Q marker in nirs Event column
samp_num = find(strncmpi('Q', nirs_tt.x_Event_, 1));
nirs_marker_time = nirs_tt.Properties.RowTimes(samp_num)

% read physiofow timetable
physio_tt = read_physioflow_tt('/Users/work/Dropbox/Shared/Nirs/sync examples/data/export/17hyp001/03_physioflow/17hyp001_t2_m2_c1_pflow.csv');

% find time of Q marker in physioflow Marks column
samp_num = find(strncmpi('Q', physio_tt.Marks, 1));
physio_marker_time = physio_tt.Properties.RowTimes(samp_num)

% determine time difference between markers (in secs)
time_diff = nirs_marker_time - physio_marker_time

% shift physio time 
physio_tt.Properties.RowTimes = physio_tt.Properties.RowTimes + time_diff;

% syncronize both table, using nearest neigbors to determine the 
% values of missing phyio samples (which has the lower sample rate).
% 'nearest' method does not work with variable 'Marks'
sync_tt = synchronize(nirs_tt, physio_tt(:,1:end-1), 'first', 'nearest');

sync_tt(1:50, :)





















