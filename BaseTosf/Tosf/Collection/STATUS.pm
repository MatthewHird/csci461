package Tosf::Collection::STATUS;
#================================================================--
# File Name    : STATUS.pm
#
# Purpose      : implements tosf status ADT
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my $cycleComplete = 1;
my $currentExecutingTask = 'none';
my $warnCount = 0;

sub inc_warnCount {
   my $self = shift @_;
   
   $warnCount = $warnCount + 1;

   return;
}

sub get_warnCount {
   my $self = shift @_;

   return $warnCount;
}

sub set_cycleComplete {
   my $self = shift @_;
   
   $cycleComplete =  Tosf::Executive::TIMER->sleep();

   return;
}

sub clear_cycleComplete {
   
   $cycleComplete =  0;

   return;
}

sub get_cycleComplete {
   my $self = shift @_;

   return $cycleComplete;
}

sub set_currentExecutingTask {
   my $self = shift @_;
   my $t = shift @_;
   
   $currentExecutingTask =  $t;

   return;
}

sub get_currentExecutingTask {
   my $self = shift @_;

   return $currentExecutingTask;
}

1;
