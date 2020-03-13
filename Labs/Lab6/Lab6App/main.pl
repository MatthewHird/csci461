#!/usr/bin/perl
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : main.pl
#
# Purpose      : main routine for Lab6App
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#========================================================

$SIG{INT} = sub {leaveScript();};

my $tc = 0;

$SIG{ALRM} = sub {
   my $tl = Tosf::Exception::Monitor->new(
      fn => sub {
         Tosf::Executive::TIMER->startISRwcet();
         print("------------------ Tick $tc -----------\n");
	 $tc = $tc + 1;
         Tosf::Executive::SCHEDULER->tick();
         Tosf::Executive::DISPATCHER->tick();
         Tosf::Executive::TIMER->stopISRwcet();
         if (Tosf::Executive::TIMER->get_clockSkew()) {
            print("Warning ..... clock skew \n");
         }

      }
   );
   $tl->run();
};


$|=1;

use strict;
use warnings;
no warnings "experimental::smartmatch";

use lib '../';

#use Sys::Mlockall qw(:all);
#if (mlockall(MCL_CURRENT | MCL_FUTURE) != 0) { die "Failed to lock RAM: $!"; }

use AnyEvent;
# use Gtk2 -init;
use Try::Tiny;
use Time::HiRes qw (ualarm usleep);
use Gnome2::Canvas;
use IO::Socket;
use Tosf::Table::QUEUE;
use Tosf::Table::PQUEUE;
use Tosf::Table::TASK;
use Tosf::Table::SEMAPHORE;
use Tosf::Record::SVar;
use Tosf::Record::Task;
use Tosf::Record::Semaphore;
use Tosf::Collection::Queue;
use Tosf::Collection::PQueue;
use Tosf::Collection::STATUS;
use Tosf::Collection::Line;
use Tosf::Exception::Trap;
use Tosf::Exception::Monitor;
use Tosf::Table::SVAR;
use Tosf::Table::TASK;
use Tosf::Table::SEMAPHORE;
use Tosf::Executive::TIMER;
use Tosf::Executive::SCHEDULER;
use Tosf::Executive::DISPATCHER;

use Lab6App::Fsm::FSM1;
use Lab6App::Fsm::FSM2;
use Lab6App::Fsm::FSM3;

use Lab6App::Plant::LAB6_APP;

use constant TRUE => 1;
use constant FALSE => 0;
#timer period in seconds
use constant TIMER_PERIOD => 1.0;
# sleep time in micro seconds
use constant NUM_SLOTS => 4;
use constant NUM_PERIODIC_PRIORITY_SLOTS => 3;

sub leaveScript {

   my $s = Tosf::Executive::TIMER->get_schedulerWCET();
   print("Scheduler WCET = $s (sec) \n");
   my $d = Tosf::Executive::TIMER->get_dispatcherWCET();
   print("Dispatcher WCET (including task execution) = $d (sec) \n");


   print("\nShutdown Now !!!!! \n");
   exit(0);
}

my $tl = Tosf::Exception::Monitor->new(
   fn => sub {

      Tosf::Executive::DISPATCHER->set_numSlots(NUM_SLOTS);
      Tosf::Executive::DISPATCHER->set_numPeriodicPrioritySlots(NUM_PERIODIC_PRIORITY_SLOTS);
      Tosf::Executive::TIMER->set_period(TIMER_PERIOD);

      Lab6App::Plant::LAB6_APP->start();

      Tosf::Executive::TIMER->start();

      while (1) {
          Tosf::Executive::TIMER->sleep();
      }

   }
);

$tl->run();

