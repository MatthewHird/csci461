#!/usr/bin/perl
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : main.pl
#
# Purpose      : main routine for Goldberg Control 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#========================================================

$SIG{INT} = sub {leaveScript();};

$SIG{ALRM} = sub {
   my $tl = Tosf::Exception::Monitor->new(
      fn => sub {
         Tosf::Executive::TIMER->startISRwcet();
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
use Gtk2 -init;
use Try::Tiny;
use Time::HiRes qw (ualarm);
use Gnome2::Canvas;
use Tosf::Record::SVar;
use Tosf::Record::Task;
use Tosf::Record::Semaphore;
use Tosf::Collection::Queue;
use Tosf::Collection::PQueue;
use Tosf::Collection::STATUS;
use Tosf::Exception::Trap;
use Tosf::Exception::Monitor;
use Tosf::Table::SVAR;
use Tosf::Table::TASK;
use Tosf::Table::SEMAPHORE;
use Tosf::Table::QUEUE;
use Tosf::Table::PQUEUE;
use Tosf::Executive::TIMER;
use Tosf::Executive::SCHEDULER;
use Tosf::Executive::DISPATCHER;
use Tosf::Fsm::To;

use miscApp::Plant::MENU;
use miscApp::Plant::LIGHTS;
use miscApp::Plant::RTSETUP;
use miscApp::Fsm::CONN;

use constant TRUE => 1;
use constant FALSE => 0;

#timer period in seconds
use constant TIMER_PERIOD => 0.002;
use constant NUM_SLOTS => 4;
use constant NUM_PERIODIC_PRIORITY_SLOTS => 4;

my $idle_event;

sub leaveScript {
   print("\nShutdown Now !!!!! \n");
   exit();
}

my $tl = Tosf::Exception::Monitor->new(
   fn => sub {

      Tosf::Executive::DISPATCHER->set_numSlots(NUM_SLOTS);
      Tosf::Executive::DISPATCHER->set_numPeriodicPrioritySlots(NUM_PERIODIC_PRIORITY_SLOTS);
      Tosf::Executive::TIMER->set_period(TIMER_PERIOD);

      miscApp::Plant::MENU->start();

      Tosf::Executive::TIMER->start();

      # Now enter Gtk2's event loop
      main Gtk2;

   }
);

$tl->run();
