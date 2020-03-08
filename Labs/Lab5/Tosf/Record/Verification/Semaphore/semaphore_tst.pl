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
use Tosf::Record::Semaphore;
use Tosf::Record::Task;
use Tosf::Collection::Queue;
use Tosf::Exception::Trap;
use Tosf::Exception::Monitor;
use Try::Tiny;
use Tosf::Record::Task;

my $y = Tosf::Record::Semaphore->new();

my $s0 = Tosf::Exception::Monitor->new(
   fn => sub {

      $y->set_max(23);
      $y->dump();
      $y->set_value(22);
      $y->dump();
      $y->signal();
   }
);

$s0->run();

