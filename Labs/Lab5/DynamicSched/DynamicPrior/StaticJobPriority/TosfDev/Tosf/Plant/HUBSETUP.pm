package goldApp::Plant::BPINGSETUP;
#================================================================--
# File Name    : BPING.pm
#
# Purpose      : Goldberg BPING Set Up
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
use constant IFACEPOLLFREQ => 0.1;


sub start {

   my $task;
   my $sem;


   #=====================================================

   $task = "BPing";
   $sem = "BPingSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(0.75),
      fsm => goldApp::Fsm::BPING->new(
         taskName => $task,
         taskSem => $sem,
	 handlerName => "GoldPacMan",
	 handlerSem => "GoldPacManSem"
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================


   #--------------------------------------------------

   my @keys = Tosf::Table::TASK->get_keys();
   my $k;

   foreach $k (@keys) {
      print("Resetting Task $k \n");
      Tosf::Table::TASK->reset($k);
   }

}

1;
