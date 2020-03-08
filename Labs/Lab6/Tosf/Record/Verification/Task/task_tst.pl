#!/usr/bin/perl
######################################################
# Peter Walsh
# File: task_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Record::Task;

my $x = Tosf::Record::Task->new();
$x->set_period(0);
$x->set_periodic(1);
$x->set_currentState(2);
$x->set_resumeTime(5);
$x->set_fsm(8);
$x->dump();

my $y = $x->get_resumeTime();
print("Resume Time  == $y \n");
