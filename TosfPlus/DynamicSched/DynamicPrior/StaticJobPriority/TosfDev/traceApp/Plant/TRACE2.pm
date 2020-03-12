package traceApp::Plant::TRACE2;
#================================================================--
# File Name    : TRACE2.pm
#
# Purpose      : Plant set-up for TRACE2
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

   my $task;
   my $sem;

   #--------------------------------------------------
   $task = "t3";
   $sem  = "t3Sem";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => TRUE, 
      period => 10,
      fsm => traceApp::Fsm::TOM->new(
         taskName => $task,
         taskSem => $sem,
         steps => 6
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
   Tosf::Table::TASK->reset($task);

   #--------------------------------------------------
   $task = "t5";
   $sem  = "t5Sem";
    
   Tosf::Table::TASK->new(
      name => $task, 
      periodic => FALSE, 
      fsm => traceApp::Fsm::JERRY->new(
         taskName => $task,
         taskSem => $sem
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 2);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
   Tosf::Table::TASK->reset($task);
    
}

1;
