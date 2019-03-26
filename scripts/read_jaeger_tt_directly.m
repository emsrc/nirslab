% example how to read jaeger files directly as timetables

clear;

tt1 = read_jaeger_tt('../../../jaeger_works_on_windows/17hyp001_t2_m2_c1_jaeg.GDT');
% 
tt2 = read_jaeger_tt('../../../jaeger_works_on_windows/17mus002_t2_jaeg.GDT');
% 
tt3 = read_jaeger_tt('../../../jaeger_works_on_windows/17mus018_t2_jaeg.GDT');
% 
% 
% 
tt4 = read_jaeger_tt('../../../jaeger_errors/17hyp001_t2_m3_c1_jaeg.GDT');
% 
tt5 = read_jaeger_tt('../../../jaeger_errors/17hyp002_t2_m3_c1_jaeg.GDT');
% 
tt6 = read_jaeger_tt('../../../jaeger_errors/17hyp003_t2_m3_c1_jaeg.GDT');
% 
tt7 = read_jaeger_tt('../../../jaeger_errors/17hyp010_t2_m3_c1_jaeg.GDT');
