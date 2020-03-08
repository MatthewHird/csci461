#!/usr/bin/perl
######################################################
# Peter Walsh
# File: TASK_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Try::Tiny;
use Tosf::Exception::Monitor;
use Tosf::Exception::Trap; 
use Tosf::Table::TASK;
use Tosf::Table::QUEUE;
use Tosf::Table::SEMAPHORE;
use Tosf::Record::Semaphore;
use Tosf::Record::Task;
use Tosf::Collection::Queue;
use Tosf::Collection::STATUS;

my $tst = Tosf::Exception::Monitor->new(
   fn => sub {
      Tosf::Table::TASK->new(
         name => "T1", 
         period => 11, 
         periodic => 1, 
         fsm => "DUMMY"
      );

      Tosf::Table::TASK->new(
         name => "T2", 
         period => 11, 
         periodic => 1, 
         fsm => "DUMMY"
      );
      
      Tosf::Table::TASK->dump();

   }
);

$tst->run();
