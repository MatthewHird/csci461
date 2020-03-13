#!/usr/bin/perl
######################################################
# Peter Walsh
# File: params_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use goldApp::Packet::Params;

my $y = goldApp::Packet::Params->new();
$y->set_p1("33");
my $message = $y->encode();
print ("message: $message \n");
$y->dump();
$y->decode($message);
$y->dump();
