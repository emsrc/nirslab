% Demo of reading Metalyzer data into a timetable

filename = '../../../metalyzer/19sar018_d2.xlsx';

tt = read_metalyzer_tt(filename);

summary(tt)

head(tt)

tt.Properties.UserData.SourceFilename

tt.Properties.UserData.Preamble
