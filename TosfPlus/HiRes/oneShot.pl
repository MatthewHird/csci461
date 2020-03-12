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
my $i=10;
my @b;
my $e;
my $n;

sub doWork() {
   usleep(1000*$i);
}

$SIG{ALRM} = sub {
   print("SIGNAL \n");
   @b = gettimeofday();
   doWork();
   $x = tv_interval(\@b);
   $e = ($x*1000000) - (1000*$i);
   print("Error $e usec\n");
   $i=$i*10;
   $n=(10000*$i);
   ualarm($n,0);
   $n=$n/1000000;
   print("New alarm $n sec \n");
};


sleep(2);
ualarm(1000000,0);
while (1) {
   # keep fan from spinning the fan
   usleep(100000000);
};
