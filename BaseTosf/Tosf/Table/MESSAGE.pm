package Tosf::Table::MESSAGE;
#================================================================--
# File Name    : Table/MESSAGE.pm
#
# Purpose      : table of messages (semaphores and queues)
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
   my $t = shift @_;
   my $m = shift @_;
   
   if ((!defined($t)) || (!defined($m))) {
      die(Tosf::Exception::Trap->new(name => "Table::MESSAGE->enqueue missing parameter(s)"));
   }

   if (!exists($table{$t})) {
      $table{$t} = Tosf::Record::Message->new(
         value => 0,
         max => 50
      );
   } 

   $table{$t}->enqueue($m);
}

sub dequeue {
   my $pkg = shift @_;
   my $t = shift @_;

   if (!defined($t)) {
      die(Tosf::Exception::Trap->new(name => "Table::MESSAGE->dequeue missing parameter"));
   }

   if (!exists($table{$t})) {
      $table{$t} = Tosf::Record::Message->new(
         value => 0,
         max => 50
      );
   } 

   return $table{$t}->dequeue();
}

sub get_siz {
   my $pkg = shift @_;
   my $q = shift @_;

   if (!defined($q)) {
      die(Tosf::Exception::Trap->new(name => "Table::MESSAGE->get_siz"));
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
      die(Tosf::Exception::Trap->new(name => "Table::MESSAGE->is_member missing params"));
   }

   if (!exists($table{$q})) {
      return FALSE;
   } 

   return $table{$q}->is_member($l);
}

1;
