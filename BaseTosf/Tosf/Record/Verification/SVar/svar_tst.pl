#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/SVar/svar_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Record::SVar;

my $y = Tosf::Record::SVar->new();
$y->set_value(3);
$y->set_nextValue(5);
$y->dump();

$y->update();

print("After update \n");
$y->dump();

$y->assign(45);

print("After after assigh \n");
$y->dump();

$y->update();

print("After second update \n");
my $x = $y->get_value();
my $w = $y->get_nextValue();
print("Current Val $x \n");
print("Next Val $w \n");
