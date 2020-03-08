package Tosf::Table::PQUEUE;
#================================================================--
# File Name    : PQUEUE.pm
#
# Purpose      : table of priority queues
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my %table;

sub enqueue {
   my $pkg = shift @_;
   my $q = shift @_;
   my $l = shift @_;
   my $p = shift @_;
   
   if (!defined($q) || (!defined($l))) {
      die(Tosf::Exception::Trap->new(name => "Table::PQUEUE->enqueue"));
   }

   if (!exists($table{$q})) {
      $table{$q} = Tosf::Collection::PQueue->new();
   } 

   $table{$q}->enqueue($l, $p);
}

sub dequeue {
   my $pkg = shift @_;
   my $q = shift @_;

   if (!defined($q)) {
      die(Tosf::Exception::Trap->new(name => "Table::PQUEUE->dequeue"));
   }

   if (exists($table{$q})) {
      return $table{$q}->dequeue();
   } else {
      return undef;
   }
}

sub get_siz {
   my $pkg = shift @_;
   my $q = shift @_;

   if (!defined($q)) {
      die(Tosf::Exception::Trap->new(name => "Table::PQUEUE->get_siz"));
   }

   if (exists($table{$q})) {
      return $table{$q}->get_siz();
   } else {
      return 0; # NB this behaviour
   }

}

1;
