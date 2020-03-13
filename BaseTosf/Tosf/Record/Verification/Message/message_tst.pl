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
use Tosf::Record::Message;
use Tosf::Record::Semaphore;
use Tosf::Collection::Queue;

my $y = Tosf::Record::Message->new(
   value => 7,
   max => 3
);

$y->dump();
