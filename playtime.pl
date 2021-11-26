#!/usr/local/bin/perl -w
use DateTime;
use Time::HiRes qw( gettimeofday tv_interval);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);

$time_epoch = time();

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time_epoch);
$mon++;
$year += 1900;
print "Server Local: $mon/$mday/$year $hour:$min:$sec\n"; 


($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time_epoch);
$mon++;
$year += 1900;
print "GMT: $mon/$mday/$year $hour:$min:$sec\n"; 

# OK, now let's play with DateTime...

$dt = DateTime->from_epoch(epoch => $time_epoch);
print "GMT: $dt\n";

$dt = DateTime->from_epoch(epoch => $time_epoch, time_zone => 'US/Mountain');
print "US/Mountain: $dt\n";

$dt = DateTime->from_epoch(epoch => $time_epoch, time_zone => 'America/Denver');
print "America/Denver: $dt\n";

$dt = DateTime->from_epoch(epoch => $time_epoch, time_zone => 'America/Los_Angeles');
print "America/Los_Angeles: $dt\n";

# Now, for the finale - construct a time object piecemeal in LA time,
# and convert it to Denver time.

$dtLA = DateTime->new( year => 2007,
  month => 7,
  day => 31,
  hour => 13,
  minute => 14,
  second => 15,
  time_zone => "America/Los_Angeles",);

print "Constructed LA time object: $dtLA\n";

$dtLA->set_time_zone("America/Denver");

print "Should be Denver time now: $dtLA\n";

$bn_year = $dtLA->year;
$bn_month = $dtLA->month;
$bn_day = $dtLA->day;
$bn_hour = $dtLA->hour;
$bn_minute = $dtLA->minute;
$bn_second = $dtLA->second;
if ($bn_month < 10) { $bn_month = "0" . $bn_month }
if ($bn_hour < 10) { $bn_hour = "0" . $bn_hour }
if ($bn_minute < 10) { $bn_minute = "0" . $bn_minute }
if ($bn_second < 10) { $bn_second = "0" . $bn_second }

print "bN time: $bn_year-$bn_month-$bn_day $bn_hour:$bn_minute:$bn_second\n";

# time trials - how long does it take to do 1000 of these conversions?

$start_time = gettimeofday;

for ($i=0;$i<1000;$i++) {
$dtLA = DateTime->new( year => 2007,
  month => 7,
  day => 31,
  hour => 13,
  minute => 14,
  second => 15,
  time_zone => "America/Los_Angeles",);
$dtLA->set_time_zone("America/Denver");
}

$end_time = gettimeofday;
$elapsed = int(100000 *($end_time - $start_time))/100000;
print "Elapsed time: $elapsed seconds\n";
