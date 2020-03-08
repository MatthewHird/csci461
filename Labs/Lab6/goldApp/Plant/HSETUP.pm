package goldApp::Plant::HUBSETUP;
#================================================================--
# File Name    : HUBSETUP.pm
#
# Purpose      : Goldberg hub Set-Up
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

   my $host;
   my $port;
   my $port0;
   my $host4 = "none";
   my $port4 = "none";


   #=====================================================

   # No error checking is performed
   
   print("*************************************************\n");
   print("*****              Hub Setup                *****\n");
   print("*************************************************\n \n");
   print("Four consecutive Tcp Internet port numbers are required \n");
   print("on localhost for Hub ports p0 through p3 \n");
   print("Enter Internet port number for Hub p0: ");
   chomp($port0 = <>);
   print("Mapping \n");
   print("\t Hub port p0 to Internet port number ", $port0, "\n");
   print("\t Hub port p1 to Internet port number ", $port0 + 1, "\n");
   print("\t Hub port p2 to Internet port number ", $port0 + 2, "\n");
   print("\t Hub port p3 to Internet port number ", $port0 + 3, "\n \n");

   print("One Tcp Internet port number is required on a connected \n");
   print("host for Hub up-link port p4 \n");
   print("Enter Internet host name for Hub p4 (enter none to disable p4): ");
   chomp($host4 = <>);
   if ($host4 ne "none") {
      print("Enter Internet port number for Hub p4: ");
      chomp($port4 = <>);
      print("Mapping \n");
      print("\t Hub up-link port p4 to Internet port number ", $host4, ":", $port4, "\n \n");
   } else {
     print("Mapping \n");
     print("\t No up-link defined \n \n");
   }

   print("*************************************************\n");
   print("*****               End Setup               *****\n");
   print("*************************************************\n \n");

   #=====================================================

   $task = "PortP0";
   $sem = "PortP0Sem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
      fsm => Tosf::Fsm::SocConC->new(
         taskName => $task,
         taskSem => $sem,
         ifaceName => "i0",
	 handlerName => "Icon",
	 handlerSem => "IconSem",
         host => $host,
         port => $port
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================

   $task = "PortP1";
   $sem = "PortP1Sem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
      fsm => Tosf::Fsm::SocConC->new(
         taskName => $task,
         taskSem => $sem,
         ifaceName => "i1",
	 handlerName => "Icon",
	 handlerSem => "IconSem",
         host => $host,
         port => $port
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================

   $task = "PortP2";
   $sem = "PortP2Sem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
      fsm => Tosf::Fsm::SocConC->new(
         taskName => $task,
         taskSem => $sem,
         ifaceName => "i2",
	 handlerName => "Icon",
	 handlerSem => "IconSem",
         host => $host,
         port => $port
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================

   $task = "PortP3";
   $sem = "PortP3Sem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(IFACEPOLLFREQ),
      fsm => Tosf::Fsm::SocConC->new(
         taskName => $task,
         taskSem => $sem,
         ifaceName => "i3",
	 handlerName => "Icon",
	 handlerSem => "IconSem",
         host => $host,
         port => $port
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================
   
   $task = "Icon";
   $sem = "IconSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => FALSE,
      fsm => Tosf::Fsm::IfaceCon->new(
         taskName => $task,
         taskSem => $sem,
	 handlerName => "HubManager",
	 handlerSem => "HubManagerSem"
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 10);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================
   
   $task = "HubManager";
   $sem = "HubManagerSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => FALSE,
      fsm => goldApp::Fsm::WMANAGER->new(
         taskName => $task,
         taskSem => $sem,
	 handlerName => "Icon",
	 handlerSem => "IconSem",
	 myMac => $mac,
	 myIface => "i0"
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 10);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================

   $task = "HBeat";
   $sem = "HBeatSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => TRUE,
      period => Tosf::Executive::TIMER->s2t(10),
      fsm => Tosf::Fsm::HBEAT->new(
         taskName => $task,
         taskSem => $sem,
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================

   $sem = "ToutSem";
   $task = "Tout";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => TRUE, 
      period => Tosf::Executive::TIMER->s2t(0.1),
      fsm => Tosf::Fsm::To->new(
         taskName => $task, 
         taskSem => $sem,
         timeOut => 500,
         timeoutSv => "sv_to"
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
