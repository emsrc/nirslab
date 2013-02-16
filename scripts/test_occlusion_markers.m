load('../../data/12ce001.mat');
test_data = subj_data.period(1).day(1).norm.nirsO.test(1);

test_data = set_occlusion_markers(test_data, 'X', 'Y', 3); 
 
label = '12ce001:period1:day:1:test1';
test_data = edit_interval_markers(test_data, 'AD1', 'X', 'Y', label);

subj_data.period(1).day(1).norm.nirsO.test(1) = test_data;

%save('../../data/12ce001.mat', 'subj_data');