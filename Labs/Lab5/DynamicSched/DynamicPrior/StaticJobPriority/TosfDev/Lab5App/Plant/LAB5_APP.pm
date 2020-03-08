package Lab5App::Plant::LAB5_APP;

#================================================================--
# File Name    : LAB5_APP.pm
#
# Purpose      : Plant set-up for LAB5_APP
#
# Author       : Matthew Hird
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE  => 1;
use constant FALSE => 0;

sub start {

    #system('clear');
    print("\n");

    my $task;
    my $sem;

    #--------------------------------------------------
    $task = "t1";
    $sem  = "t1Sem";

    Tosf::Table::TASK->new(
        name     => $task,
        periodic => TRUE,
        period   => 8,
        wcet     => 5,
        fsm      => traceApp::Fsm::FOO->new(
            taskName => $task,
            taskSem  => $sem,
            steps    => 5
        )
    );

    Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
    Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
    Tosf::Table::TASK->reset($task);

    #--------------------------------------------------
    $task = "t2";
    $sem  = "t2Sem";

    Tosf::Table::TASK->new(
        name     => $task,
        periodic => TRUE,
        period   => 7,
        wcet     => 2,
        fsm      => traceApp::Fsm::FOO->new(
            taskName => $task,
            taskSem  => $sem,
            steps    => 2
        )
    );

    Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
    Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
    Tosf::Table::TASK->reset($task);

}

1;
