#!/usr/bin/perl
######################################################
# Peter Walsh
# File: gold_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use goldApp::Packet::Gold;

my $y = goldApp::Packet::Gold->new();
$y->set_srcMac("33");
$y->set_destMac("44");
$y->set_opcode("opcode");
$y->set_msg("Peter");
$y->set_err("Paul");

my $message = $y->encode();
print ("message: $message \n");
$y->dump();
$y->decode($message);
$y->dump();
