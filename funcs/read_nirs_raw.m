function subj = read_nirs_raw(subj, day, system, filename)
% read_nirs_raw(subj, day, system, filename)
%
% Read raw oxymon data into subject data

assert(regexp(system, '^(nirsO|nirsP|nirsO_od|nirsP_od)$', 'stringanchors') == 1,...
    'unknown system: %s', system);

subj.day(day).(system) = read_oxysoft_output(filename);

end

