package Lab6App::Plant::TRACE0;
#================================================================--
# File Name    : TRACE0.pm
#
# Purpose      : Plant set-up for TRACE0
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
      fsm => Lab6App::Fsm::FOO->new(
         taskName => $task,
         taskSem => $sem,
         steps => 10
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
   Tosf::Table::TASK->reset($task);

}

1;
