
clear;

marker = 'X';
tolerance = seconds(1:5);


filename = '../../../polar/03_polar/15nit001/15nit001_s1_polar.xlsx'
tt1 = read_polar_tt(filename, marker, tolerance);
head(tt1)

filename = '../../../polar/03_polar/15nit001/15nit001_s2_polar.xlsx'
tt2 = read_polar_tt(filename, marker, tolerance);
head(tt2)



filename = '../../../polar/03_polar/15nit002/15nit002_s1_polar.xlsx'
tt3 = read_polar_tt(filename, marker, tolerance);
head(tt3)

filename = '../../../polar/03_polar/15nit002/15nit002_s2_polar.xlsx'
tt4 = read_polar_tt(filename, marker, tolerance);
head(tt4)
