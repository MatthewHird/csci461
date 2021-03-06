package Tosf::Record::Semaphore;

#================================================================--
# File Name    : Semaphore.pm
#
# Purpose      : implements Semaphore record
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE  => 1;
use constant FALSE => 0;

my $value = 0;
my $max   = 1;
my $class;

sub new {
    $class = shift @_;
    my %params = @_;

    if (defined($params{value})) {
        $value = $params{value};
    }

    if (defined($params{max})) {
        $max = $params{max};
    }

    my $self = {
        value        => $value,
        max          => $max,
        waitQueue    => Tosf::Collection::Queue->new(),
        runningTasks => {}
    };

    bless($self, $class);
    return $self;
}

sub get_max {
    my $self = shift @_;

    return $self->{max};
}

sub set_max {
    my $self = shift @_;
    my $m    = shift @_;

    $self->{max} = $m;
    return;
}

sub get_value {
    my $self = shift @_;

    return $self->{value};
}

sub set_value {
    my $self = shift @_;
    my $v    = shift @_;

    $self->{value} = $v;
    return;
}

sub wait {
    my $self = shift @_;
    my $task = shift @_;

    if ($self->{value} == 0) {
        Tosf::Table::TASK->set_blocked($task, TRUE);
        Tosf::Table::TASK->set_blockingSemRef($task, $self);
        $self->{waitQueue}->enqueue($task);
        my $tempPriority = Tosf::Table::TASK->get_tempPriority($task);

        $self->update_tempPriority($tempPriority - 1);
    } else {
        $self->{value} = $self->{value} - 1;
        $self->{runningTasks}{$task} = TRUE;
    }

    return;
}

sub signal {
    my $self = shift @_;
    my $task = shift @_;

    if (exists($self->{runningTasks}{$task})) {
        delete($self->{runningTasks}{$task});
    }

    Tosf::Table::TASK->reset_tempPriority($task);

    my $q_size = $self->{waitQueue}->get_siz();
    if ($q_size > 0) {
        my $next_task = $self->{waitQueue}->dequeue();
        Tosf::Table::TASK->set_blocked($next_task, FALSE);
        $self->{runningTasks}{$next_task} = TRUE;
        my $tempPriority = $self->get_waitQueueMaxPriority();
        $self->update_tempPriority($tempPriority - 1);

    } else {
        if ($self->{value} < $self->{max}) {
            $self->{value} = $self->{value} + 1;
        } else {
            die(Tosf::Exception::Trap->new(
                    name =>
                        "Record::Semaphore->signal signal when value == max"
                )
            );
        }
    }

    return;
}

sub update_tempPriority {
    my $self         = shift @_;
    my $tempPriority = shift @_;

    foreach my $k (keys %{$self->{runningTasks}}) {
        print("\nUPDATE TEMP PRIORITY $tempPriority Task $k\n");
        Tosf::Table::TASK->update_tempPriority($k, $tempPriority);
    }
}

sub get_waitQueueMaxPriority {
    my $self        = shift @_;
    my $maxPriority = -1;

    foreach my $k (@{$self->{waitQueue}->{queue}}) {
        my $k_tp = Tosf::Table::TASK->get_tempPriority($k);
        if ($maxPriority == -1 || $k_tp > -1 && $k_tp < $maxPriority) {
            $maxPriority = $k_tp;
        }
    }
    return $maxPriority;
}

sub resume {
    my $self = shift @_;
    my $task = shift @_;

    # assume task is suspend on semaphore
    # only to be used by the SCHEDULER

    $task = $self->{waitQueue}->delete($task);
    Tosf::Table::TASK->set_blocked($task, FALSE);

    return;
}

sub dump {
    my $self = shift @_;

    print("Value: $self->{value} \n");
    print("Max: $self->{max} \n");
    $self->{waitQueue}->dump();
    return;
}

1;
