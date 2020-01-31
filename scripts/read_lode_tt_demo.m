% Demo of reading Lode data into a timetable

filename = '../../../lode/19sar006_d1a_lode.xls';

tt = read_lode_tt(filename);

summary(tt)

head(tt)

tt.Properties.UserData.Subject

tt.Properties.UserData.Devices

tt.Properties.UserData.LEM

