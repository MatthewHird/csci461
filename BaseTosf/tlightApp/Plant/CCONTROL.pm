package tlightApp::Plant::CCONTROL;
#================================================================--
# File Name    : CCONTROL.pm
#
# Purpose      : Centralized traffic light physical plant
#                (control set up)
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

   my $task;
   my $sem;

   Tosf::Table::SVAR->add(name => "sv_car", value => 0);
   Tosf::Table::SVAR->add(name => "sv_lto", value => 0);
   Tosf::Table::SVAR->add(name => "sv_sto", value => 0);

   #--------------------------------------------------
   $task = "CentralCon";
   $sem  = "CentralConSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(0.1),
      fsm => tlightApp::Fsm::CCON->new(
         taskName => $task,
         taskSem => $sem
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #--------------------------------------------------
   $task = "CentralDisp";
   $sem  = "CentralDispSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => FALSE,
      fsm => tlightApp::Fsm::CDISP->new(
         taskName => $task,
         taskSem => $sem
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 50);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #--------------------------------------------------
   $task = "Sto";
   $sem  = "StoSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => FALSE,
      fsm => Tosf::Fsm::ATo->new(
         taskName => $task,
         taskSem => $sem,
         timeoutSv => "sv_sto",
         timeOut =>  Tosf::Executive::TIMER->s2t(5)
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 5);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #--------------------------------------------------
   $task = "Lto";
   $sem  = "LtoSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => FALSE,
      fsm => Tosf::Fsm::ATo->new(
         taskName => $task,
         taskSem => $sem,
         timeoutSv => "sv_lto",
         timeOut =>  Tosf::Executive::TIMER->s2t(15)
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 5);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #--------------------------------------------------
   my @keys = Tosf::Table::TASK->get_keys();
   my $k;

   foreach $k (@keys) {
      print("Resetting Task $k \n");
      Tosf::Table::TASK->reset($k);
   }

}

1;
