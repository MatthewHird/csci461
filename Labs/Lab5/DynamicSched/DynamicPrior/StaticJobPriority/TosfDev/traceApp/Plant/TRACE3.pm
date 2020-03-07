package traceApp::Plant::TRACE3;
#================================================================--
# File Name    : TRACE3.pm
#
# Purpose      : Plant set-up for TRACE3
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE => 1;
use constant FALSE => 0;

sub start {
   #system('clear');
   print("\n");

   Tosf::Table::SEMAPHORE->add(name => "mutex", value => 1, max => 1);
   # for mutual exclusion
   Tosf::Table::SEMAPHORE->add(name => "empty", value => 5, max => 5);
   # number of empty "buffer" spaces
   Tosf::Table::SEMAPHORE->add(name => "full", value => 0, max => 5);
   # number of full "buffer" spaces

   my $task;
   my $sem;

   #--------------------------------------------------
   $task = "p1";
   $sem  = "p1Sem";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => FALSE, 
      fsm => traceApp::Fsm::PRODUCER->new(
         taskName => $task,
         taskSem => $sem
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
   Tosf::Table::TASK->reset($task);

   #--------------------------------------------------
   $task = "p2";
   $sem  = "p2Sem";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => FALSE, 
      fsm => traceApp::Fsm::PRODUCER->new(
         taskName => $task,
         taskSem => $sem
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
   Tosf::Table::TASK->reset($task);

   #--------------------------------------------------
   $task = "c1";
   $sem  = "c1Sem";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => FALSE, 
      fsm => traceApp::Fsm::CONSUMER->new(
         taskName => $task,
         taskSem => $sem
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
   Tosf::Table::TASK->reset($task);

}

1;
