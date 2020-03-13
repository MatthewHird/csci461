package Tosf::Record::Task;
#================================================================--
# File Name    : Task.pm
#
# Purpose      : implements Task record
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

sub  new {
   my $class = shift @_;

   my $self = {
      name => my $name = ' ',
      period => my $period = ' ',
      # for periodic tasks
      periodic => my $periodic = ' ',
      resumeTime => my $resumeTime = -1,
      blocked => my $blocked = 0,
      blockingSemRef => my $blockingSemRef = ' ',
      fsm => my $fsm,
      currentState => my $currentState = "dummy current state",
      nextState => my $nextState = "dummy next state",
      tempPriority => my $tempPriority = -1
   };
                
   bless ($self, $class);
   return $self;
}
sub get_blocked {
   my $self = shift @_;
   
   return $self->{blocked};
}

sub set_blocked {
   my $self = shift @_;
   my $b = shift @_;
 
   $self->{blocked} = $b;
   return;
}

sub get_blockingSemRef {
   my $self = shift @_;
   
   return $self->{blockingSemRef};
}

sub set_blockingSemRef {
   my $self = shift @_;
   my $ref = shift @_;
 
   $self->{blockingSemRef} = $ref;
   return;
}


sub get_name {
   my $self = shift @_;
   
   return $self->{name};
}

sub set_name {
   my $self = shift @_;
   my $n = shift @_;
 
   $self->{name} = $n;
   return;
}

sub get_period {
   my $self = shift @_;
   
   return $self->{period};
}

sub set_period {
   my $self = shift @_;
   my $p = shift @_;
 
   $self->{period} = $p;
   return;
}

sub get_periodic {
   my $self = shift @_;

   return $self->{periodic};
}

sub set_periodic {
   my $self = shift @_;
   my $pflag = shift @_;
 
   $self->{periodic} = $pflag;
   return;
}

sub get_resumeTime {
   my $self = shift @_;
   
   return $self->{resumeTime};
}

sub set_resumeTime {
   my $self = shift @_;
   my $rt = shift @_;
 
   $self->{resumeTime} = $rt;
   return;
}

sub get_tempPriority {
   my $self = shift @_;
   
   return $self->{tempPriority};
}

sub set_tempPriority {
   my $self = shift @_;
   my $tp = shift @_;
 
   $self->{tempPriority} = $tp;
   return;
}

sub get_fsm {
   my $self = shift @_;

   return $self->{fsm};
}

sub set_fsm {
   my $self = shift @_;
   my $f = shift @_;

   $self->{fsm} = $f;
   return;
}

sub get_currentState {
   my $self = shift @_;
   
   return $self->{currentState};
}

sub set_currentState {
   my $self = shift @_;
   my $s = shift @_;
 
   $self->{currentState} = $s;
   return;
}

sub get_nextState {
   my $self = shift @_;
   
   return $self->{nextState};
}

sub set_nextState {
   my $self = shift @_;
   my $s = shift @_;
 
   $self->{nextState} = $s;
   return;
}

sub dump {
   my $self = shift @_;

   print ("Name: $self->{name} \n");
   print ("Period: $self->{period} \n");
   print ("Periodic: $self->{periodic} \n");
   print ("Resume Time: $self->{resumeTime} \n");
   print ("Blocked: $self->{blocked} \n");
   print ("FSM: $self->{fsm} \n");
   print ("Current State: $self->{currentState} \n");
   print ("Next State: $self->{nextState} \n");
   return;
}

1;
