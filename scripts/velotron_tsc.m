tsc = read_velotron_tsc('../../../data/velotron/12ce001_p1d1_vel.txt')

% slice single time series
subsample1 = getsampleusingtime(tsc.speed, 250, 750)

% slice time series colection
tsc_subsample = getsampleusingtime(tsc, 250, 750)

% set events for times series 'speed' 
tsc.speed = tsc.speed.addevent('I', 250);
tsc.speed = tsc.speed.addevent('J', 750);

% display events
tsc.speed.Events(1)
tsc.speed.Events(2)
tsc.speed.Events(1).Name
tsc.speed.Events(1).Time

% find events
tsc.speed.Events.findEvent('I')

% slice between events
subsample2 = tsc.speed.gettsbetweenevents('I', 'J')

% copy event to other time series
tsc.watts.events = tsc.speed.events;
tsc.rpm.events = tsc.speed.events;
tsc.KM.events = tsc.speed.events; 





