package miscApp::Plant::RTSETUP;
#================================================================--
# File Name    : RTSETUP.pm
#
# Purpose      : Reaction Tester  Set-Up
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

   Tosf::Table::SVAR->add(name => "sv_react", value => 0);
   Tosf::Table::SVAR->add(name => "sv_lto", value => 0);
   Tosf::Table::SVAR->add(name => "sv_sto", value => 0);

   $sem = "STOSEM";
   $task = "STO";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => TRUE, 
      period => Tosf::Executive::TIMER->s2t(0.1),
      fsm => Tosf::Fsm::To->new(
         taskName => $task, 
         taskSem => $sem,
         timeOut => 50,
         timeoutSv => "sv_sto"
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
     
   $sem = "LTOSEM";
   $task = "LTO";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => TRUE, 
      period => Tosf::Executive::TIMER->s2t(0.1),
      fsm => Tosf::Fsm::To->new(
         taskName => $task, 
         taskSem => $sem,
         timeOut => 100,
         timeoutSv => "sv_lto"
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
      
   $sem = "CONNSEM";
   $task = "CONN";

   Tosf::Table::TASK->new(
      name => "CONN", 
      periodic => TRUE, 
      period => Tosf::Executive::TIMER->s2t(0.05),
      fsm => miscApp::Fsm::CONN->new(
         taskName => $task, 
         taskSem => $sem,
         period => 0.01
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
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
