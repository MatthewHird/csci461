package goldApp::Plant::GCLIENTSETUP;
#================================================================--
# File Name    : GCLIENTSETUP.pm
#
# Purpose      : Goldberg GUI Client Set-Up
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
use constant SERVERMAC => 0;


sub start {

   my $task;
   my $sem;

   my $host;
   my $port;
   my $mac;

   Tosf::Table::SVAR->add(name => "sv_regReq", value => 0);
   Tosf::Table::SVAR->add(name => "sv_regAck", value => 0);
   Tosf::Table::SVAR->add(name => "sv_go", value => 0);
   Tosf::Table::SVAR->add(name => "sv_to", value => 0);
   Tosf::Table::SVAR->add(name => "sv_stop", value => 0);

   #=====================================================

   print("Enter Internet host name ");
   chomp($host = <>);
   print("Enter Internet port number: ");
   chomp($port = <>);
   print("Enter : Distributed Goldberg mac address: ");
   chomp($mac = <>);

   Tosf::Table::SVAR->add(name => "my_mac", value => $mac);

   # No error checking is performed
   
   #=====================================================

   $task = "Port";
   $sem = "PortSem";

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

   Tosf::Table::SVAR->add(name => "my_iface", value => "i0");

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
	 handlerName => "HostManager",
	 handlerSem => "HostManagerSem"
      )
   );

   Tosf::Table::SEMAPHORE->add(name => $sem, max => 10);
   Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);

   #=====================================================
   
   $task = "HostManager";
   $sem = "HostManagerSem";

   Tosf::Table::TASK->new(
      name => $task,
      periodic => FALSE,
      fsm => goldApp::Fsm::HOSTMANAGER->new(
         taskName => $task,
         taskSem => $sem,
	 handlerName => "Icon",
	 handlerSem => "IconSem"
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
     
   #=====================================================

   $sem = "GuiClientControlSem";
   $task = "GuiClientControl";

   Tosf::Table::TASK->new(
      name => $task, 
      periodic => TRUE, 
      period => Tosf::Executive::TIMER->s2t(0.1),
      fsm => goldApp::Fsm::GCLIENTCONTROL->new(
         taskName => $task, 
         taskSem => $sem,
	 handlerName => "HostManager",
	 handlerSem => "HostManagerSem",
         period => 0.1
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
