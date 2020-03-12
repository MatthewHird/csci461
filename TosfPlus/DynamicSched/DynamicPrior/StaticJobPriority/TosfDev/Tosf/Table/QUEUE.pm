package Tosf::Table::QUEUE;
#================================================================--
# File Name    : Table/QUEUE.pm
#
# Purpose      : table of queues
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use constant FALSE => 0;

my %table;

sub enqueue {
   my $pkg = shift @_;
   my $q = shift @_;
   my $l = shift @_;
   
   if (!defined($q) || (!defined($l))) {
      die(Tosf::Exception::Trap->new(name => "Table::QUEUE->enqueue"));
   }

   if (!exists($table{$q})) {
      $table{$q} = Tosf::Collection::Queue->new();
   } 

   $table{$q}->enqueue($l);
}

sub dequeue {
   my $pkg = shift @_;
   my $q = shift @_;

   # note that empty queues are not deleted from the table

   if (!defined($q)) {
      die(Tosf::Exception::Trap->new(name => "Table::QUEUE->dequeue"));
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
      die(Tosf::Exception::Trap->new(name => "Table::QUEUE->get_siz"));
   }

   if (exists($table{$q})) {
      return $table{$q}->get_siz();
   } else {
      return 0; # NM this behaviour
   }

}

sub is_member {
   my $pkg = shift @_;
   my $q = shift @_;
   my $l = shift @_;

   if (!defined($q) || (!defined($l))) {
      die(Tosf::Exception::Trap->new(name => "Table::QUEUE->is_member missing params"));
   }

   if (!exists($table{$q})) {
      return FALSE;
   } 

   return $table{$q}->is_member($l);
}

1;
