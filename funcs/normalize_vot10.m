function raw = normalize_vot10(raw, varargin)
% norm = normalize_vot10(raw)
% norm = normalize_vot10(raw, systems)
% 
% Normalize test data
%
% Examples:
% normalize_vot10(raw)
% normalize_vot10(raw, {'nirsO'})

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

% Default
systems = {'nirsO'};
if nargin > 1, systems = varargin{1}; end

for nirs = systems
    nirs = nirs{1};
    
    
    test_data = raw.(nirs);
    
    %col_numbers = find(colsel(test_data, '(O2Hb|HHb|tHb|HbDiff)'));
    col_numbers = find(colsel(test_data, 'O2Hb'));
    
    %col_numbers_tsi = find(colsel(test_data, 'TSI'));
    
    for col_n=col_numbers'
        % exstract data
        samples = test_data.samples{col_n};
        % find vot period
        vot10_st = test_data.events('I');
        vot10_end = test_data.events('J');
        t1 = vot10_st(:,1);
        t2 = vot10_end(:,1);
        % calculate min and max VOT10
        signal_max = max(samples(t1:t2,:));
        signal_min = min(samples(t1:t2,:));
        % normalization for columns O2Hb, HHb, tHb and Hbdiff
%         if any(col_n == col_numbers_tsi)
%             samples = (samples - signal_min)/(signal_max - signal_min)*100;
%         end
            
        for col_id = col_n:col_n+3;
            % normalization signals
            samples = (samples - signal_min)/(signal_max - signal_min)*100;
            % replace samples in struct
            raw.(nirs).samples{col_n} = samples;
        end
    end
end

