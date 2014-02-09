%==========================================================================
% Example script: computing group means over an event interval determined
% by two event markers
%==========================================================================

warning on;

subjects = [4 6 10];
days = 1:2;

% filename pattern for normalized data
norm_file_pat = '../../../data/13doms%03d/13doms%03d_d%d_filt.mat';

% systems (nirsP and or nirsO)
systems = {'nirsP'};

% range of test (non-existing test are skipped)
tests = 1:1;

% event markers (non-existing markers are skipped)
start_marker = 'A';
end_marker = 'B';

% range of events (non-existing events are skipped)
events = 1:1;

% negative (positive) offset before (after) start marker, in samples
start_offset = -100;

% positive (negative) offset after (before) end marker, in samples
end_offset = 100;

% signal patterns
% NB each pattern should match exactly ONE signal
signal_patterns = {'.303. R1 - T1 HHb', '.303. R1 - T1 O2Hb'}; 

% normalize: rescale signal by assuming zero at start marker
% (or at first sample in case of a positive start offset)
normalize = 1;


% -------------------------------------------------------------
% 1. pre-load all norm data in memory
% -------------------------------------------------------------

for s = subjects
    for d = days
        filename = sprintf(norm_file_pat, s, s, d);
        
        try
            obj = load(filename);
        catch err
            if strcmp(err.identifier, 'MATLAB:load:couldNotReadFile')
                warning(err.message)
                continue
            else
                rethrow(err)
            end
        end
        
        fprintf('loaded norm data file %s\n', filename);
        norm.subj(s).day(d) = obj.norm;
    end
end


% -------------------------------------------------------------
% 2. compute group means
% -------------------------------------------------------------

for pat = signal_patterns
    for d = days
        for sys=systems
            for t = tests
                for n = events
                    % use cellmat to store signals, because length of
                    % longest signal is not known yet
                    sig_cell = cell(1, max(subjects));
                    % init maximum #samples found (=longest signal)  
                    max_samp_found = 0;
                    % init minimum #samples found (=shortest signal)
                    min_samp_found = max_samples;
                    
                    for s = subjects
                        try
                            data = norm.subj(s).day(d).(sys{1}).test(t);
                        catch exception
                            warning('no data for subj %d, day %d, system %s, test %d',...
                                s, d, sys{1}, t);
                            continue
                        end                        
                       
                        try                            
                            % to see the whole test with group mean, use:
                            % sig = colmat(data, pat{1});    
                            sig = events_colmat(data,...
                                start_marker, end_marker, ...
                                start_offset, end_offset, ...
                                n, pat{1});
                        catch err
                            if strcmp(err.identifier, 'MATLAB:Containers:Map:NoKey')
                                warning('no such event marker for subj %d, day %d, sytem %s, test %d, start marker %s, end_marker %s, event %d, signal %s',...
                                    s, d, sys{1}, t, start_marker, end_marker, n, pat{1});
                            elseif strcmp(err.identifier, 'MATLAB:badsubscript')
                                warning('no such event interval for subj %d, day %d, sytem %s, test %d, start marker %s, end_marker %s, event %d, signal %s',...
                                    s, d, sys{1}, t, start_marker, end_marker, n, pat{1});
                            else
                                warning('error for subj %d, day %d, sytem %s, test %d, start marker %s, end_marker %s, event %d, signal %s: %s',...
                                    s, d, sys{1}, t, start_marker, end_marker, n, pat{1}, err.message);
                            end
                            continue                            
                        end
                        
                        samp_found = length(sig);
                        sig_cell{s} = sig;
                        % update sample count of longest and shortest
                        % signals (if necessary)
                        max_samp_found = max(samp_found, max_samp_found); 
                        min_samp_found = min(samp_found, min_samp_found);
                    end
                    
                    if max_samp_found == 0
                        warning('no events for any subject on day %d, sytem %s, test %d, start marker %s, end_marker %s, event %d, signal %s',...
                            d, sys{1}, t, start_marker, end_marker, n, pat{1});
                        continue
                    end
                    
                    % create empty matrix for storing subjects' signals
                    signals = zeros(max_samp_found, max(subjects));
                    signals(:,:) = NaN;
                    
                    % copy signals from cellmat to normal mat
                    for s=1:max(subjects)
                        sig = sig_cell{s};
                        signals(1:length(sig), s) = sig;
                    end                    
                    
                    if normalize == 1
                        % subtract value at event marker from whole signal 
                        norm_sample = max(1, -start_offset + 1);               
                        signals = bsxfun(@minus, signals, signals(norm_sample,:));
                    end
                    
                    % compute group mean from start upto end of shortest
                    % signal (discounting offset)
                    group_mean = nanmean(signals, 2);                    
                    group_mean = group_mean(1:min_samp_found - end_offset);
                    
                    %-----------------------------------------------------
                    % do something useful here, e.g plot, call a function                    
                    %-----------------------------------------------------
                    figure;
                    plot(signals,'b');
                    hold on;
                    plot(group_mean,'k');
                end
            end
        end
    end
end
                



        
    
        

