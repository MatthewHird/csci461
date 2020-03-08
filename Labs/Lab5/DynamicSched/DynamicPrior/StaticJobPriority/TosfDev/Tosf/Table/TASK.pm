package Tosf::Table::TASK;

#=======================================================================
# File Name    : TASK.pm
#
# Purpose      : table of Task records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
# Revisions     :
#     Matthew Hird    Mar 2020    Add methods for wcet and elapsedTime
#
#=======================================================================

$| = 1;
use strict;
use warnings;

my %table;

sub get_keys {

    return keys(%table);
}

sub new {
    my $pkg    = shift @_;
    my %params = @_;

    if (defined($params{name})) {
        if (!exists($table{$params{name}})) {
            $table{$params{name}} = Tosf::Record::Task->new();
            $table{$params{name}}->set_name($params{name});
        } else {
            die(Tosf::Exception::Trap->new(name => "Table::TASK->new name $params{name} is a duplicate"));
        }
    } else {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->new name undefined"));
    }

    if (defined($params{periodic})) {
        $table{$params{name}}->set_periodic($params{periodic});
    } else {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->new periodic undefined"));
    }

    if ($params{periodic}) {
        if (defined($params{period})) {
            $table{$params{name}}->set_period($params{period});
            $table{$params{name}}->set_resumeTime(0);
        } else {
            die(Tosf::Exception::Trap->new(name => "Table::TASK->new period undefined"));
        }

        if (defined($params{wcet})) {
            $table{$params{name}}->set_wcet($params{wcet});
            $table{$params{name}}->set_elapsedTime(0);
        } else {
            die(Tosf::Exception::Trap->new(name => "Table::TASK->new wcet undefined"));
        }
    }

    if (defined($params{resumeTime})) {
        $table{$params{name}}->set_resumeTime($params{resumeTime});
    }

    if (defined($params{fsm})) {
        $table{$params{name}}->set_fsm($params{fsm});
    } else {
        die(Tosf::Exception::Trap->new(name => "nofsm", description => "Missing FSM reference"));
    }
}

sub reset {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->reset name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->reset name = $name not in table"));
    }

    my $fsm = Tosf::Table::TASK->get_fsm($name);
    Tosf::Table::TASK->set_nextState($name, $fsm->reset($name));

}

sub get_nextState {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_nextState name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_nextState name = $name not in table"));
    }

    return ($table{$name}->get_nextState());
}

sub set_nextState {
    my $pkg   = shift @_;
    my $name  = shift @_;
    my $state = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_nextState name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_nextState name = $name not in table"));
    }

    $table{$name}->set_nextState($state);
    return;
}

sub get_period {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_period name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_period name = $name not in table"));
    }

    return ($table{$name}->get_period());
}

sub get_periodic {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_periodic name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_periodic name = $name not in table"));
    }

    return ($table{$name}->get_periodic());
}

sub get_resumeTime {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_resumeTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_resumeTime name = $name not in table"));
    }

    return ($table{$name}->get_resumeTime());
}

sub get_fsm {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_fsm name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_fsm name = $name not in table"));
    }

    return ($table{$name}->get_fsm());
}

sub get_timeOut {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_timeOut name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_timeOut name = $name not in table"));
    }

    return $table{$name}->get_timeOut();
}

sub set_timeOut {
    my $pkg  = shift @_;
    my $name = shift @_;
    my $t    = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_timeOut name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_timeOut name = $name not in table"));
    }

    $table{$name}->set_timeOut($t);
}

sub get_blockingSemRef {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_blockingSemRef name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_blockingSemRef name = $name not in table"));
    }

    return $table{$name}->get_blockingSemRef();
}

sub set_blockingSemRef {
    my $pkg  = shift @_;
    my $name = shift @_;
    my $ref  = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_blockingSemRef name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_blockingSemRef name = $name not in table"));
    }

    if (!defined($ref)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_blockingSemRef reference undefined"));
    }

    $table{$name}->set_blockingSemRef($ref);
}

sub get_blocked {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_blocked name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_blocked name = $name not in table"));
    }

    return $table{$name}->get_blocked();
}

sub set_blocked {
    my $pkg  = shift @_;
    my $name = shift @_;
    my $b    = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_blocked name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_blocked name = $name not in table"));
    }

    $table{$name}->set_blocked($b);
}

sub decrement_resumeTime {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->decrement_resumeTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->decrement_resumeTime name $name not in table"));
    }

    my $t = $table{$name}->get_resumeTime();
    if ($t >= 0) {
        $table{$name}->set_resumeTime($t - 1);
    }
}

sub increase_resumeTime {
    my $pkg  = shift @_;
    my $name = shift @_;
    my $val  = shift @_;    # assume positive integer

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->increase_resumeTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->increase_resumeTime name $name not in table"));
    }

    if (!defined($val)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->increase_resumeTime val undefined"));
    }

    my $t = $table{$name}->get_resumeTime();
    $table{$name}->set_resumeTime($t + $val);
}

sub set_resumeTime {
    my $pkg  = shift @_;
    my $name = shift @_;
    my $val  = shift @_;    # assume -1 .. max int

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_resumeTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_resumeTime name $name not in table"));
    }

    if (!defined($val)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_resumeTime val undefined"));
    }

    $table{$name}->set_resumeTime($val);
}

sub clear_resumeTime {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->clear_resumeTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->clear_resumeTime name $name not in table"));
    }

    $table{$name}->set_resumeTime(0);
}

sub get_wcet {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_wcet name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_wcet name = $name not in table"));
    }

    return ($table{$name}->get_wcet());
}

sub set_wcet {
    my $pkg  = shift @_;
    my $name = shift @_;
    my $val  = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_wcet name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_wcet name $name not in table"));
    }

    if (!defined($val)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_wcet val undefined"));
    }

    $table{$name}->set_wcet($val);
}

sub get_elapsedTime {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_elapsedTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->get_elapsedTime name = $name not in table"));
    }

    return ($table{$name}->get_elapsedTime());
}

sub set_elapsedTime {
    my $pkg  = shift @_;
    my $name = shift @_;
    my $val  = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_elapsedTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_elapsedTime name $name not in table"));
    }

    if (!defined($val)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->set_elapsedTime val undefined"));
    }

    $table{$name}->set_elapsedTime($val);
}

sub increment_elapsedTime {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->increment_elapsedTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->increment_elapsedTime name $name not in table"));
    }

    my $t = $table{$name}->get_elapsedTime();
    $table{$name}->set_elapsedTime($t + 1);
}

sub reset_elapsedTime {
    my $pkg  = shift @_;
    my $name = shift @_;

    if (!defined($name)) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->reset_elapsedTime name undefined"));
    }

    if (!exists($table{$name})) {
        die(Tosf::Exception::Trap->new(name => "Table::TASK->reset_elapsedTime name $name not in table"));
    }

    $table{$name}->set_elapsedTime(0);
}

sub dump {
    my $self = shift @_;

    my $key;

    foreach $key (keys(%table)) {
        print("Name: $key \n");
        $table{$key}->dump();
        print("\n");
    }
}

1;
