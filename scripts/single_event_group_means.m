%==========================================================================
% Example script: computing group means over an event interval determined
% by a single event and offsets
%==========================================================================

warning on;

subjects = [4 6 8 10];
days = 1:2;

% filename pattern for normalized data
norm_file_pat = '../../../data/13doms%03d/13doms%03d_d%d_filt.mat';

% systems (nirsP and or nirsO)
systems = {'nirsP'};

% range of test (non-existing test are skipped)
tests = 1:1;

% event marker (non-existing markers are skipped)
marker = 'B';

% range of events (non-existing events are skipped)
events = 1:1;

% offset before marker (<=0), in samples
left_offset = -200;

% offset after marker (>=0), in samples
right_offset = 500;

% signal patterns
% NB each pattern should match exactly ONE signal
signal_patterns = {'.303. R1 - T1 HHb', '.303. R1 - T1 O2Hb'}; 

% normalize: rescale signal by assuming zero at marker
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
                    n_samples = -left_offset + right_offset + 1;
                    signals = zeros(n_samples, max(subjects));
                    signals(:,:) = NaN;
                    
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
                            signals(:,s) = event_colmat(data, marker, ...
                                left_offset, right_offset, n, pat{1});
                        catch err
                            if strcmp(err.identifier, 'MATLAB:Containers:Map:NoKey')
                                warning('no such event marker for subj %d, day %d, sytem %s, test %d, marker %s, event %d, signal %s',...
                                    s, d, sys{1}, t, marker, n, pat{1});
                            elseif strcmp(err.identifier, 'MATLAB:badsubscript')
                                warning('no such event interval for subj %d, day %d, sytem %s, test %d, marker %s, event %d, signal %s',...
                                    s, d, sys{1}, t, marker, n, pat{1});
                            else
                                warning('error for subj %d, day %d, sytem %s, test %d, marker %s, event %d, signal %s: %s',...
                                    s, d, sys{1}, t, marker, n, pat{1}, err.message);
                            end
                            continue                            
                        end
                    end
                    
                    if all(isnan(signals(:)))
                        warning('no events for any subject on day %d, sytem %s, test %d, marker %s, event %d, signal %s',...
                            d, sys{1}, t, marker, n, pat{1});
                        continue
                    end
                    
                    if normalize == 1
                        % subtract value at event marker from whole signal 
                        signals = bsxfun(@minus, signals, signals(-left_offset+1,:));
                    end
                    
                    group_mean = nanmean(signals, 2);             
                    
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
                



        
    
        

