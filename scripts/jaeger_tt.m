% How to convert Jaeger table to timetable

data = load('/Users/work/Dropbox/Shared/Nirs/sync examples/data/jaeger/17hyp001_t1_m1_c1_jaeg.mat');
data.JT.Time = seconds(data.times);
tt = table2timetable(data.JT, 'RowTimes', 'Time');
head(tt)
