package Lab6App::Plant::LAB6_APP;

#================================================================--
# File Name    : LAB6_APP.pm
#
# Purpose      : Plant set-up for LAB6_APP
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

    Tosf::Table::SEMAPHORE->add(name => "mutex", value => 1, max => 1);

    my $task;
    my $sem;

    #--------------------------------------------------
    $task = "t1";
    $sem  = "t1Sem";

    Tosf::Table::TASK->new(
        name     => $task,
        periodic => TRUE,
        period   => 6,
        fsm      => Lab6App::Fsm::DELAY_CRIT->new(
            taskName    => $task,
            taskSem     => $sem,
            delayLength => 1,
            critLength  => 1
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
        period   => 8,
        fsm      => Lab6App::Fsm::FOO->new(
            taskName => $task,
            taskSem  => $sem,
            steps    => 2
        )
    );

    Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
    Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
    Tosf::Table::TASK->reset($task);

    #--------------------------------------------------
    $task = "t3";
    $sem  = "t3Sem";

    Tosf::Table::TASK->new(
        name     => $task,
        periodic => TRUE,
        period   => 11,
        fsm      => Lab6App::Fsm::DELAY_CRIT->new(
            taskName    => $task,
            taskSem     => $sem,
            delayLength => 0,
            critLength  => 2
        )
    );

    Tosf::Table::SEMAPHORE->add(name => $sem, max => 1);
    Tosf::Table::SEMAPHORE->wait(semaphore => $sem, task => $task);
    Tosf::Table::TASK->reset($task);

}

1;
