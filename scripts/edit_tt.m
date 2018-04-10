
% read nirs timetable
nirs_dat = load('/Users/work/Dropbox/Shared/Nirs/sync examples/data/norm/17hyp001/17hyp001_t2_m2_c1_norm.mat'); 
nirs_tt = nirs_to_tt(nirs_dat.norm.nirsO.test(1));

signal_names = {'x_109_Rx1_Tx1HHb', 'x_303_Rx1_Tx1O2Hb'};
event_name = 'x_Event_';
start_marker = 'F';
end_marker = 'G';
no_marker = '0';
label = 'my plot';

nirs_tt = edit_interval_markers_tt(nirs_tt, signal_names, event_name, start_marker, end_marker, no_marker, label);
