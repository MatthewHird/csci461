#!/usr/bin/perl
######################################################
# Peter Walsh
# File: QUEUE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Table::QUEUE;
use Tosf::Collection::Queue;
use Try::Tiny;
use Tosf::Exception::Trap;

my $s = Tosf::Table::QUEUE->get_siz('peter');
print("Siz of peter is $s \n");
Tosf::Table::QUEUE->enqueue('peter', "xx");
$s = Tosf::Table::QUEUE->get_siz('peter');
print("Siz of peter is $s \n");
my $t = Tosf::Table::QUEUE->dequeue('peter');
$s = Tosf::Table::QUEUE->get_siz('peter');
print("Siz of peter is $s \n");

do {
   try {
      my $pkt = "CCCCCC";
      Tosf::Table::QUEUE->enqueue('peter', $pkt);
      my $ret=Tosf::Table::QUEUE->dequeue('peter');
      print ($ret, "\n");

      $pkt = "DDDD";
      Tosf::Table::QUEUE->enqueue('peter', $pkt);
      $ret=Tosf::Table::QUEUE->dequeue('peter');
      print ($ret, "\n");

      $a = Tosf::Table::QUEUE->is_member('paul', $pkt);
      print("Is member paul EEEE $a \n");

      $pkt = "EEEE";
      Tosf::Table::QUEUE->enqueue('paul', $pkt);
      my $a = Tosf::Table::QUEUE->is_member('paul', $pkt);
      print("Is member paul EEEE $a \n");

      $ret=Tosf::Table::QUEUE->dequeue('paul');
      print ($ret, "\n");

      $a = Tosf::Table::QUEUE->is_member('paul', $pkt);
      print("Is member paul EEEE $a \n");
   }

   catch {
      my $cew_e = $_;
      if (ref($cew_e) ~~ "Tosf::Exception::Trap") {
         my $exc_name = $cew_e->get_name();
         print("FATAL ERROR: $exc_name \n");
      } else {
         die("ref($cew_e)");
      }
   }
}

