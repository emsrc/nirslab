load('/Users/work/Dropbox/Shared/Nirs/transfer markers/17mus004_t2_jaeg_tt.mat');
load('/Users/work/Dropbox/Shared/Nirs/transfer markers/17mus004_t2_nirs_tt.mat');

tt_jaeg(:,'Event') = {''};

tt_markers(tt_jaeg, 'Event')
tt_markers(tt_nirs, 'x_Event_')

tt = transfer_markers(tt_nirs, tt_jaeg, 'x_Event_', 'Event', 'R', false, 'FG', seconds(0:1:12));

tt_markers(tt, 'Event')



