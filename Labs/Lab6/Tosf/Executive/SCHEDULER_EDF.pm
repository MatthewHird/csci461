package Tosf::Executive::SCHEDULER_EDF;
#================================================================--
# File Name    : SCHEDULER_EDF.pm
#
# Purpose      : EDF schedular
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
#no warnings "experimental::smartmatch";
use Time::HiRes qw (ualarm usleep gettimeofday tv_interval);

my $tme; # for WCET calculation
my @tod;

my $k;
my $periodic;
my $inq;
my $blocked;
my $rtime;
my $bs;
my @keys;

sub tick {

   @tod = gettimeofday();

   @keys = Tosf::Table::TASK->get_keys();

   Tosf::Table::SVAR->update_all();

   foreach $k (@keys) {

      $blocked = Tosf::Table::TASK->get_blocked($k);
      $rtime = Tosf::Table::TASK->get_resumeTime($k);
      $periodic = Tosf::Table::TASK->get_periodic($k); 

      if ($rtime == 0) {

         if ($blocked) { 

            if ($periodic) {
               $rtime = Tosf::Table::TASK->get_period($k);
            } else {
               $rtime = -1; 
            }

            Tosf::Table::TASK->set_resumeTime($k, $rtime);

	    $bs = Tosf::Table::TASK->get_blockingSemRef($k); 
	    $bs->resume($k);
            $blocked = Tosf::Table::TASK->get_blocked($k);

            # uncomment the following to run the trace examples 
	    #print("SCHEDULER: resume task $k  \n");

         } else {
            die(Tosf::Exception::Trap->new(name => "Executive::SCHEDULER->tick attempted to resume non-blocked task $k"));
         }
      }

      if (!$blocked) {
        
         if ($periodic) {
            Tosf::Table::PQUEUE->enqueue('pTask', $k, $rtime);
             # uncomment the following to run the trace examples  
	     #print("SCHEDULER: ready periodic task $k with priority $rtime \n");
         } else {
            $inq = Tosf::Table::QUEUE->is_member('apTask', $k);
             # uncomment the following to run the trace examples  
	     #print("SCHEDULER: ready aperiodic task $k \n");
            if (!$inq) {
               Tosf::Table::QUEUE->enqueue('apTask', $k);
            }
            # Note, this task is enqueued on a non priority queue
         }
      }


      if ($rtime >= 1) {
         Tosf::Table::TASK->decrement_resumeTime($k);
      }
   }

   $tme = tv_interval(\@tod);
   Tosf::Executive::TIMER->update_schedulerWCET($tme);

}

1;
