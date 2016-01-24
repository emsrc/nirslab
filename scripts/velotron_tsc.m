% Examples how to use velotron timeseries


tsc = read_velotron_tsc('../../../data/velotron/12ce001_p1d1_vel.txt')

disp('### slice single time series from time 250 to 750 ###')
subsample1 = getsampleusingtime(tsc.speed, 250, 750)

disp('### slice time series colection from time 250 to 750 ###')
tsc_subsample = getsampleusingtime(tsc, 250, 750)

disp('### set events "I" and "J" for times series "speed" ###') 
tsc.speed = tsc.speed.addevent('I', 250);
tsc.speed = tsc.speed.addevent('J', 750);
tsc.speed = tsc.speed.addevent('I', 1000);
tsc.speed = tsc.speed.addevent('J', 1500);

disp('### display first and second events ###')
tsc.speed.Events(1)
tsc.speed.Events(2)
tsc.speed.Events(1).Name
tsc.speed.Events(1).Time

disp('### find first event "I" ###')
tsc.speed.Events.findEvent('I')

disp('### find second event "I" ###')
tsc.speed.Events.findEvent('I',2)

disp('### slice ts "speed" between second events "I" and "J" ###')
subsample2 = tsc.speed.gettsbetweenevents('I', 'J', 2, 2);

disp('### copy event from ts "speed" to other time series ###')
tsc.watts.events = tsc.speed.events;
tsc.rpm.events = tsc.speed.events;
tsc.KM.events = tsc.speed.events; 

disp('### edit markers ###')
tsc.speed = edit_interval_markers_ts(tsc.speed, 'I', 'J', 'my example');

for e=tsc.speed.Events
    e
end




