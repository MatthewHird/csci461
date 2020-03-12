#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Packet/Verification/Work/work_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Packet::Work;

my $y = Tosf::Packet::Work->new();
$y->set_par("Params");
$y->set_iface("I0");
$y->set_opcode("opcode");
$y->set_msg("Peter");

my $message = $y->encode();
print ("message: $message \n");
$y->dump();
$y->decode($message);
$y->dump();
