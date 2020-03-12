#!/usr/bin/perl
######################################################
# Peter Walsh
# File: PQUEUE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Table::PQUEUE;
use Tosf::Collection::PQueue;
use Try::Tiny;
use Tosf::Exception::Trap;

my $s = Tosf::Table::PQUEUE->get_siz('peter');
print("Siz of peter is $s \n");
Tosf::Table::PQUEUE->enqueue('peter', "xx", 3);
$s = Tosf::Table::PQUEUE->get_siz('peter');
print("Siz of peter is $s \n");
my $t = Tosf::Table::PQUEUE->dequeue('peter');
$s = Tosf::Table::PQUEUE->get_siz('peter');
print("Siz of peter is $s \n");

do {
    try {
        my $pkt = "CCCCCC";
        Tosf::Table::PQUEUE->enqueue('peter', $pkt, 23);
        my $ret = Tosf::Table::PQUEUE->dequeue('peter');
        print($ret, "\n");

        $pkt = "DDDD";
        Tosf::Table::PQUEUE->enqueue('peter', $pkt, 62);
        $ret = Tosf::Table::PQUEUE->dequeue('peter');
        print($ret, "\n");

        $pkt = "EEEE";
        Tosf::Table::PQUEUE->enqueue('paul', $pkt, 3);
        $ret = Tosf::Table::PQUEUE->dequeue('paul');

        print($ret, "\n");
    }

    catch {
        my $cew_e = $_;
        if (ref($cew_e) ~~ "Tosf::Exception::Trap") {
            my $exc_name = $cew_e->get_name();
            print("FATAL ERROR: $exc_name \n");
        }
        else {
            die("ref($cew_e)");
        }
    }
    }

