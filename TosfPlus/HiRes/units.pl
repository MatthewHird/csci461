#!/usr/bin/perl

# One-shot timers 
# Also can  measure interval between two points in the code.
# Can be used for WCET estimation.

# Peter Walsh csci 461 2020

use Time::HiRes qw (ualarm usleep gettimeofday tv_interval);
use warnings;
use strict;
$|=1;

my $x;
my @b;

sub doWork() {
   usleep(1000000); # sleep 1 sec
}

$SIG{ALRM} = sub {
   print("SIGNAL \n");
   @b = gettimeofday();
   doWork();
   $x = tv_interval(\@b);
   print("Elapsed time $x (sec) \n");
};


sleep(2);
ualarm(1000000,0);
while (1) {
   # keep fan from spinning the fan
   usleep(100000000);
};

