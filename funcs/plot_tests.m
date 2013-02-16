function plot_tests(nirso_data, nirsp_data)
pattern = '(O2Hb|HHb|tHb|HbDiff)';

%pattern = 'Rx1 - Tx1a';
selection = colsel(nirso_data, pattern);
samples = cell2mat(nirso_data.samples(selection));
nirso_time = ((0:size(samples,1)-1) / nirso_data.export_sample_rate) / 60;
subplot(2,1,1);
plot(nirso_time', samples);
legend(nirso_data.legend(selection))
xlabel('Minutes');
title('Oxymon');
xlim(xlim() * 1.25);
nirso_xlim = xlim();

hold on;
start_time = event_times(nirso_data, 'i') / 60000;
plot([start_time, start_time],ylim(),':k');
end_time = event_times(nirso_data, 'j') / 60000;
plot([end_time,end_time],ylim(),':k');
hold off;

%pattern = '\[303\] R1 - T2 ';
selection = colsel(nirsp_data, pattern);
samples = cell2mat(nirsp_data.samples(selection));
nirsp_time = ((0:size(samples,1)-1) / nirsp_data.export_sample_rate) / 60;
subplot(2,1,2);
plot(nirsp_time', samples);
legend(nirsp_data.legend(selection));
xlabel('Minutes');
title('Portamon');
xlim(nirso_xlim);

hold on;
start_time = event_times(nirsp_data, 'i') / 60000;
plot([start_time, start_time],ylim(),':k');
end_time = event_times(nirsp_data, 'j') / 60000;
plot([end_time,end_time],ylim(),':k');
hold off;

end