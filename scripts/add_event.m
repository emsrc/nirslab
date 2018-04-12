% how to create new event columns and insert markers


% read physiofow timetable
physio_tt = read_physioflow_tt('/Users/work/Dropbox/Shared/Nirs/sync examples/data/export/17hyp001/03_physioflow/17hyp001_t2_m2_c1_pflow.csv');

% create a new events variable 
events = cell(height(physio_tt),1);
events(:) = {''};

% add events column to timetabe 
physio_tt.Events = events;

% insert some markers by position
physio_tt{3, 'Events'} = {'F'};
physio_tt{6, 'Events'} = {'G'};
physio_tt{7, 'Events'} = {'X'};

% delete X marker
physio_tt{7, 'Events'} = {''};

% insert marker at certain point in time
physio_tt(seconds(1), 'Events') = {'A'};

% show top of table
head(physio_tt)

% show F-G interval
f = find(strncmpi('F', physio_tt.Events, 1));
g = find(strncmpi('G', physio_tt.Events, 1));
physio_tt(f:g, :)

