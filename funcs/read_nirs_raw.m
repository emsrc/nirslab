function subj = read_nirs_raw(subj, period, day, system, filename)
% read_oxymon(filename)
%
% Read raw oxymon data into subject data

assert(regexp(system, '^(nirsO|nirsP|nirsO_od|nirsP_od)$', 'stringanchors') == 1,...
    'unknown system: %s', system);

subj.period(period).day(day).raw.(system) = read_oxysoft_output(filename);

end

