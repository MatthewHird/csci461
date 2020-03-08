package Tosf::Executive::SCHEDULER;

#===================================================================
# File Name    : SCHEDULER.pm
#
# Purpose      : LLF schedular
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
# Revisions     :
#     Matthew Hird    Mar 2020    Change scheduler from EDF to LLF
#
#===================================================================

$| = 1;
use strict;
use warnings;

#no warnings "experimental::smartmatch";
use Time::HiRes qw (ualarm usleep gettimeofday tv_interval);

my $tme;    # for WCET calculation
my @tod;

my $taskName;
my $periodic;
my $inq;
my $blocked;
my $rtime;
my $bs;
my @taskNames;
my $wcet;
my $elapsedTime;

sub tick {

    @tod = gettimeofday();

    @taskNames = Tosf::Table::TASK->get_keys();

    Tosf::Table::SVAR->update_all();

    foreach $taskName (@taskNames) {

        $blocked  = Tosf::Table::TASK->get_blocked($taskName);
        $rtime    = Tosf::Table::TASK->get_resumeTime($taskName);
        $periodic = Tosf::Table::TASK->get_periodic($taskName);
        $wcet = Tosf::Table::TASK->get_wcet($wcet);
        $elapsedTime = Tosf::Table::TASK->get_elapsedTime($elapsedTime);

        if ($rtime == 0) {

            if ($blocked) {

                if ($periodic) {
                    $rtime = Tosf::Table::TASK->get_period($taskName);
                } else {
                    $rtime = -1;
                }

                Tosf::Table::TASK->set_resumeTime($taskName, $rtime);
                Tosf::Table::TASK->reset_elapsedTime($taskName);

                $bs = Tosf::Table::TASK->get_blockingSemRef($taskName);
                $bs->resume($taskName);
                $blocked = Tosf::Table::TASK->get_blocked($taskName);

                # uncomment the following to run the trace examples
                #print("SCHEDULER: resume task $taskName  \n");

            } else {
                die(Tosf::Exception::Trap->new(
                        name => "Executive::SCHEDULER->tick attempted to resume non-blocked task $taskName"
                    )
                );
            }
        }

        if (!$blocked) {

            if ($periodic) {
                # Laxity = deadline - (current_instant_of_time + Remaining_WCET) 
                # Laxity = deadline - current_instant_of_time - Remaining_WCET 
                # rtime = deadline - current_instant_of_time
                # Laxity = rtime - Remaining_WCET
                # Remaining_WCET = wcet - elapsedTime 
                # Laxity = rtime - (wcet - elapsedTime)
                # Laxity = rtime - wcet + elapsedTime
                # Laxity = rtime + elapsedTime - wcet 
                my $laxity = $rtime + $elapsedTime - $wcet;
                Tosf::Table::PQUEUE->enqueue('pTask', $taskName, $laxity);

                # uncomment the following to run the trace examples
                #print("SCHEDULER: ready periodic task $taskName with priority $rtime \n");
            } else {
                $inq = Tosf::Table::QUEUE->is_member('apTask', $taskName);

                # uncomment the following to run the trace examples
                #print("SCHEDULER: ready aperiodic task $taskName \n");
                if (!$inq) {
                    Tosf::Table::QUEUE->enqueue('apTask', $taskName);
                }

                # Note, this task is enqueued on a non priority queue
            }
        }

        if ($rtime >= 1) {
            Tosf::Table::TASK->decrement_resumeTime($taskName);
        }
    }

    $tme = tv_interval(\@tod);
    Tosf::Executive::TIMER->update_schedulerWCET($tme);

}

1;
