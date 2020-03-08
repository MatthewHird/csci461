package Tosf::Executive::TIMER;
#================================================================--
# File Name    : Executive/TIMER.pm
#
# Purpose      : timer
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
#no warnings "experimental::smartmatch";
use Time::HiRes qw (ualarm usleep gettimeofday tv_interval);


my $sec = 1.0;
# wcet calculation
my $tme;
my @tod;
my $schedulerWCET = 0;
my $dispatcherWCET = 0;

sub set_period {
   my $self = shift @_;
   $sec = shift @_;
}

# signal alarm in 2.5s & every .1s thereafter
#   ualarm(2_500_000, 100_000);

sub sleep {
   return usleep(1000000);
}

sub start {
   my $self = shift @_;

   my $usec = int($sec * 1000000);
   print("usec $usec \n");

   Time::HiRes::ualarm(1000_000, $usec);
}

#convert seconds to ticks
sub s2t {
   my $self = shift @_;
   my $s = shift @_;

   return int($s / $sec);
}

#convert ticks to seconds
sub t2s {
   my $self = shift @_;
   my $t = shift @_;

   return($t * $sec);
}

sub update_dispatcherWCET {
   my $self = shift @_;
   my $t = shift @_;

   if ($t > $dispatcherWCET) {
      $dispatcherWCET = $t;
   }
}

sub update_schedulerWCET {
   my $self = shift @_;
   my $t = shift @_;

   if ($t > $schedulerWCET) {
      $schedulerWCET = $t;
   }
}

sub get_schedulerWCET {

   return ($schedulerWCET);
}

sub get_dispatcherWCET {

   return ($dispatcherWCET);
}

sub startISRwcet {
   @tod = gettimeofday();
}

sub stopISRwcet {
   $tme = tv_interval(\@tod);
}

sub get_clockSkew {

   return ($tme > $sec);

}

1;
