package Tosf::Executive::DISPATCHER;

#================================================================--
# File Name    : DISPATCHER.pm
#
# Purpose      : execute scheduled tasks
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use Time::HiRes qw (ualarm usleep gettimeofday tv_interval);

my $num_slots = 1;
my $num_pps   = 1;
my $key;
my $fsm;
my $slot_count;
my $aqsiz;
my $pqsiz;
my $periodic_siz;     # number of periodic slots in this frame
my $aperiodic_siz;    # number of aperiodic slots in this frame

my $tme;              # for WCET calculation
my @tod;

sub set_numSlots {
    my $self = shift @_;
    $num_slots = shift @_;
}

sub set_numPeriodicPrioritySlots {
    my $self = shift @_;
    $num_pps = shift @_;
    if ($num_pps > $num_slots) {
        die(Tosf::Exception::Trap->new(
                name =>
                    "Executive::DISPATCHER->tick num periodic priority slots  > number of slots "
            )
        );
    }
}

sub calcLoopLimits {
    my $ns   = shift(@_);
    my $npp  = shift(@_);
    my $psiz = shift(@_);
    my $asiz = shift(@_);

    my $num_periodic;
    my $num_aperiodic;

    if ($psiz >= $npp) {
        $num_periodic = $npp;
    } else {
        $num_periodic = $psiz;
    }

    if ($asiz >= $ns - $npp) {
        $num_aperiodic = $ns - $npp;
    } else {
        $num_aperiodic = $asiz;
    }

    while ((($num_periodic + $num_aperiodic) < $ns)
        && (($num_periodic + $num_aperiodic) < ($asiz + $psiz)))
    {
        if ($num_periodic < $psiz) {
            $num_periodic++;
        } elsif ($num_aperiodic < $asiz) {
            $num_aperiodic++;
        }
    }

    return ($num_periodic, $num_aperiodic);
}

sub tick {

    @tod = gettimeofday();

    $aqsiz = Tosf::Table::QUEUE->get_siz('apTask');
    $pqsiz = Tosf::Table::PQUEUE->get_siz('pTask');

    ($periodic_siz, $aperiodic_siz)
        = calcLoopLimits($num_slots, $num_pps, $pqsiz, $aqsiz);

    $slot_count = 0;

# uncomment the following to run the trace examples
#print("DISPATCHER: number of periodic  tasks to be executed in this frame $periodic_siz \n");
#print("DISPATCHER: number of aperiodic  tasks to be executed in this frame $aperiodic_siz \n");

    while ($slot_count < $periodic_siz) {
        $slot_count = $slot_count + 1;
        $key        = Tosf::Table::PQUEUE->dequeue('pTask');
        Tosf::Collection::STATUS->set_currentExecutingTask($key);
        $fsm = Tosf::Table::TASK->get_fsm($key);
        Tosf::Table::TASK->set_nextState($key,
            $fsm->tick(Tosf::Table::TASK->get_nextState($key)));
    }

    # dequeue remaining periodic tasks and throw away
    while (Tosf::Table::PQUEUE->get_siz('pTask')) {
        $key = Tosf::Table::PQUEUE->dequeue('pTask');
    }

    $slot_count = 0;

    while ($slot_count < $aperiodic_siz) {
        $slot_count = $slot_count + 1;
        $key        = Tosf::Table::QUEUE->dequeue('apTask');
        Tosf::Collection::STATUS->set_currentExecutingTask($key);
        $fsm = Tosf::Table::TASK->get_fsm($key);
        Tosf::Table::TASK->set_nextState($key,
            $fsm->tick(Tosf::Table::TASK->get_nextState($key)));
    }

    # aperiodic tasks are executed round-robin

    $tme = tv_interval(\@tod);
    Tosf::Executive::TIMER->update_dispatcherWCET($tme);

}

1;
