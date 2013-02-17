
norm_filename = '~/tmp/data/norm/12ce003/12ce003_p1_d1_norm.mat';
load(norm_filename, 'norm');
test_data = norm.nirsO.test(1);

test_data = set_occlusion_markers(test_data, 'X', 'Y', 3); 

test_data.events('X')
test_data.events('Y')
 
label = '12ce003:period1:day:1:test1';
test_data = edit_interval_markers(test_data, 'AD1', 'X', 'Y', label);

norm.nirsO.test(1) = test_data;

test_data.events('X')
test_data.events('Y')



backup_filename = '~/tmp/backup.mat';
backup_events(test_data, backup_filename)



% clear markers
test_data.events('X') = [];
test_data.events('Y') = [];

test_data.events('X')
test_data.events('Y')



restore_events(test_data, backup_filename, {'X' 'Y'})

test_data.events('X')
test_data.events('Y')

