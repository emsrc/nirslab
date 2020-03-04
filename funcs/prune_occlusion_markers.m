function test = prune_occlusion_markers( test, ...
    start_marker, end_marker, min_samp)
% prune occlusion markers if interval is shorter than min_samp samples

warning('nirslab:deprecated', 'function %s is deprecated!', mfilename('fullpath'))
% Hint: to switch off these warning messages, use
% >> warning('off', 'nirslab:deprecated')

starts = test.events(start_marker);
ends = test.events(end_marker);
index = ends - starts > min_samp ;
test.events(start_marker) = starts(index);
test.events(end_marker) = ends(index);

end

