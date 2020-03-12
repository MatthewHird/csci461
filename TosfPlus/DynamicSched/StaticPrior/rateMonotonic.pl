#!/usr/bin/perl

# Rate Monotic Simulation
# Variation on RIOS

# Peter Walsh csci 461 2020

# T0 = (10, 3) T1 = (12, 4)
# T2 = (20, 1) T4 = (50, 8)

use Time::HiRes qw (ualarm);
use warnings;
use strict;
$|=1;

# signal alarm in 2.5s & every .1s thereafter
#ualarm(2_500_000, 100_000);

my @p; # period
my @c; # period count down time
my @w; # WCET
my @a; # allotted cpu time (ticks)
my @r; # process ready

$p[0]=10;$c[0]=$p[0];$w[0]=3;$r[0]=1;$a[0]=0;
$p[1]=12;$c[1]=$p[1];$w[1]=4;$r[1]=1;$a[1]=0;
$p[2]=20;$c[2]=$p[2];$w[2]=1;$r[2]=1;$a[2]=0;
$p[3]=45;$c[3]=$p[3];$w[3]=6;$r[3]=1;$a[3]=0;
$p[4]=50;$c[4]=$p[4];$w[4]=8;$r[4]=1;$a[4]=0;

my $i;
my $ticks = 0;
my $nextSchedEventTime = 10; 
my $cpuTicksAvailable = $nextSchedEventTime;

sub printCurrentState() {
   print("Start of Scheduling Event ..... Current State \n");
   for ($i=0; $i<5; $i++) {
      print("Task $i Ready $r[$i] WCET $w[$i] cpu ticks $a[$i] \n");
   }
}

printCurrentState();
print("Next scheduling event will be in $nextSchedEventTime ticks\n");
print("Run dispatcher \n");

ualarm(1000000, 1000000);
$SIG{ALRM} = sub {
   if ($ticks == $nextSchedEventTime) {
      # scheduling event
      printCurrentState();
      print("Run scheduler\n");
      $nextSchedEventTime = 50; # max period
      for ($i=0; $i<5; $i++) {
         $c[$i] = $c[$i] - $ticks;
         if (!$r[$i] && ($c[$i] == 0)) {
            $c[$i] = $p[$i];
	    $r[$i] = 1;
	    print("Task $i released \n");
         } 
         if (($c[$i] !=0) && $c[$i] < $nextSchedEventTime) {
            $nextSchedEventTime = $c[$i];
	 }
      }
      $ticks = 0;
      $cpuTicksAvailable = $nextSchedEventTime;
      print("Next scheduling event will be in $nextSchedEventTime ticks\n");
      print("Run dispatcher \n");
   } else {
      $ticks = $ticks + 1;
   }

   for ($i=0; $i<5; $i++) {
      if ($r[$i] && $cpuTicksAvailable) {
         $a[$i] = $a[$i] + 1;
	 $cpuTicksAvailable = $cpuTicksAvailable - 1;
         if ($a[$i] == $w[$i]) {
            print("Task $i completed after receiving $a[$i] cpu ticks \n");
            $r[$i] = 0;
	    $a[$i] = 0;
	 }
	 last;
      }
   }
};

while (1) {
}

