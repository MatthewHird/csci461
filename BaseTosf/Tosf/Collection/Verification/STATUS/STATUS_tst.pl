#!/usr/bin/perl
######################################################
# Peter Walsh
# File: STATUS_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Collection::STATUS;

my $x;
Tosf::Collection::STATUS->set_cycleComplete(0);
$x=Tosf::Collection::STATUS->get_cycleComplete();
my $y;
Tosf::Collection::STATUS->set_cycleComplete(1);
$y=Tosf::Collection::STATUS->get_cycleComplete();

print(" cycleComplete $x , $y \n");


