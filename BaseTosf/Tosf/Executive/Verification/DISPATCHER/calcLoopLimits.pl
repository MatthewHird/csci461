#!/usr/bin/perl

# Simple script to determine how many periodic and aperiodic 
# tasks are executed in a given frame. calcLoopLimits()
# is a helper function for the DISPATCHER.
# Test input is not verified.
# Peter walsh

use strict;
use warnings;

my $num_slots;
my $num_periodic_priority;
my $num_periodic_ready;
my $num_aperiodic_ready;
my @ans;

sub calcLoopLimits {
   my $ns = shift(@_);
   my $npp = shift(@_);
   my $psiz = shift(@_);
   my $asiz = shift(@_);

   my $num_periodic;
   my $num_aperiodic;

   if ($psiz >= $npp) {
      $num_periodic = $npp;
   } else {
      $num_periodic = $psiz;
   }

   if ($asiz >= $ns - $npp) {
      $num_aperiodic = $ns - $npp;
   } else {
      $num_aperiodic = $asiz;
   }

   while ((($num_periodic + $num_aperiodic) < $ns) && (($num_periodic + $num_aperiodic) < ($asiz + $psiz))) {
      if ($num_periodic < $psiz) {
         $num_periodic++;
      } elsif ($num_aperiodic < $asiz) {
         $num_aperiodic++;
      }

   }

   return ($num_periodic, $num_aperiodic);

}


while (1) {
   print("Enter num slots (CTRL C to exit) ");
   $num_slots = <>;
   chop($num_slots);
   print("Enter periodic priority ");
   $num_periodic_priority = <>;
   chop($num_periodic_priority);
   print("Enter number of ready periodic tasks ");
   $num_periodic_ready = <>;
   chop($num_periodic_ready);
   print("Enter number of ready aperiodic tasks ");
   $num_aperiodic_ready = <>;
   chop($num_aperiodic_ready);
   @ans = calcLoopLimits($num_slots, $num_periodic_priority, $num_periodic_ready, $num_aperiodic_ready);
   print("Number of periodic tasks to be executed in this frame  = $ans[0] \n");
   print("Number of aperiodic tasks to be executed in this frame  = $ans[1] \n \n");
}
