clear;

load('/Users/work/Dropbox/Shared/Nirs/velotron markers/data/timetables/17mus003/17mus003_t2_pflow_tt.mat');

tt = extend_tt(tt_pflow, 45);

tt_cat = concat_tt(tt, tt_pflow);

tt_cat(3190:3210,:)












