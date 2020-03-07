#!/usr/bin/perl
######################################################
# Peter Walsh
# File: SEMAPHORE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Try::Tiny;
use Tosf::Exception::Trap;
use Tosf::Exception::Monitor;
use Tosf::Record::Semaphore;
use Tosf::Record::Task;
use Tosf::Table::SEMAPHORE;
use Tosf::Table::TASK;
use Tosf::Table::QUEUE;
use Tosf::Collection::Queue;
use Tosf::Collection::STATUS;
use constant TRUE => 1;
use constant FALSE => 0;

my $tst = Tosf::Exception::Monitor->new(
   fn => sub {
      Tosf::Table::SEMAPHORE->add(name => "S1", value => 0, max => 2);
      Tosf::Table::SEMAPHORE->dump();
      my $val = Tosf::Table::SEMAPHORE->get_value("S1");
      my $max = Tosf::Table::SEMAPHORE->get_max("S1");
      Tosf::Table::SEMAPHORE->signal(semaphore => "S1");
      Tosf::Table::SEMAPHORE->signal(semaphore => "S1");
      print("Two signals \n");
      Tosf::Table::SEMAPHORE->dump();
      $val = Tosf::Table::SEMAPHORE->get_value("S1");
      $max = Tosf::Table::SEMAPHORE->get_max("S1");
      Tosf::Table::SEMAPHORE->signal(semaphore => "S1");
      print("One more signal \n");
      Tosf::Table::SEMAPHORE->dump();
      $val = Tosf::Table::SEMAPHORE->get_value("S1");
      $max = Tosf::Table::SEMAPHORE->get_max("S1");

      print"===========\n";
      Tosf::Table::SEMAPHORE->dump();
      print"===========\n";
      Tosf::Collection::STATUS->set_currentExecutingTask("T9");
      Tosf::Table::TASK->new(name => "T9", periodic => 1, period => 10, run => TRUE, elapsedTime => 3, fsm => "dummy");
      Tosf::Table::SEMAPHORE->add(name => "S9");

      Tosf::Table::SEMAPHORE->wait(semaphore => "S9");
      Tosf::Table::SEMAPHORE->dump();

      #print("======resume ==========\n");
      #Tosf::Table::SEMAPHORE->resume(semaphore => "S9", task => "T9");
      #Tosf::Table::SEMAPHORE->dump();
      # resume is now a direct call on the sem record (see SCHEDULER.pm)
      Tosf::Table::SEMAPHORE->add(name => "SS", value => 1, max => 2);

   }
);

$tst->run();
