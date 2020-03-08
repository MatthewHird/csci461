package traceApp::Fsm::BAR;

#================================================================--
# File Name    : BAR.pm
#
# Purpose      : implements task BAR (to demonstrate
#                 a simple scheduling trace).
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

sub new {
   my $class  = shift @_;
   my %params = @_;

   my $self = {
      taskName => my $taskName,
      taskSem  => my $taskSem,
      steps    => my $steps,
      count    => my $count,
      resume   => my $resume
   };

   if ( defined( $params{taskName} ) ) {
      $self->{taskName} = $params{taskName};
   }
   else {
      die(
         Tosf::Exception::Trap->new( name => "Task::BAR taskName undefined" ) );
   }

   if ( defined( $params{taskSem} ) ) {
      $self->{taskSem} = $params{taskSem};
   }
   else {
      die(
         Tosf::Exception::Trap->new( name => "Task::BAR taskSem undefined" ) );
   }

   if ( defined( $params{steps} ) ) {
      $self->{steps} = $params{steps};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Task::BAR steps (execution time) undefined"
         )
      );
   }

   if ( defined( $params{resume} ) ) {
      $self->{resume} = $params{resume};
   }
   else {
      die( Tosf::Exception::Trap->new( name => "Task::BAR resume undefined" ) );
   }

   bless( $self, $class );
   return $self;
}

sub set_name {
   my $self = shift @_;
   my $nme  = shift @_;

   return $nme;
}

sub tick {
   my $self             = shift @_;
   my $mmt_currentState = shift @_;
   no warnings "experimental::smartmatch";

   if ( $mmt_currentState ~~ "S1" ) {
      print( "BAR: task ", $self->{taskName}, " executing step ",
         $self->{count}, "\n" );

      $self->{count} = $self->{count} + 1;

      if ( $self->{count} == $self->{steps} ) {
         $self->{count} = 0;
         print( "BAR: wait on semaphore ", $self->{taskSem}, "\n" );
         Tosf::Table::SEMAPHORE->wait( semaphore => $self->{taskSem} );
         Tosf::Table::TASK->set_resumeTime( $self->{taskName},
            $self->{resume} );
      }
      return ( "S1" );
   }

}

sub reset {
   my $self = shift @_;

   $self->{count} = 0;
   print( "BAR: signal semaphore ", $self->{taskSem}, "\n" );
   Tosf::Table::SEMAPHORE->signal( semaphore => $self->{taskSem} );

   return ("S1");
}

1;
