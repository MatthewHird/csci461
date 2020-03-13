package Lab6App::Fsm::FOO;

#================================================================--
# File Name     : FOO.pm
#
# Purpose        : implements task FOO (to demonstrate
#                      a simple scheduling trace).
#
# Author         : Peter Walsh, Vancouver Island University
#
# System         : Perl (Linux)
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
      count    => my $count
   };

   if ( defined( $params{taskName} ) ) {
      $self->{taskName} = $params{taskName};
   }
   else {
      die(
         Tosf::Exception::Trap->new( name => "Task::FOO taskName undefined" ) );
   }

   if ( defined( $params{taskSem} ) ) {
      $self->{taskSem} = $params{taskSem};
   }
   else {
      die(
         Tosf::Exception::Trap->new( name => "Task::FOO taskSem undefined" ) );
   }

   if ( defined( $params{steps} ) ) {
      $self->{steps} = $params{steps};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Task::FOO steps (execution time) undefined"
         )
      );
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

   if ( $mmt_currentState ~~ "S0" ) {
      print( "Resume Time: ",
         Tosf::Table::TASK->get_resumeTime( $self->{taskName} ), ";\n" );

      $self->{count} = $self->{count} + 1;

      print( "FOO: Task ", $self->{taskName}, " -> section ", $self->{count},
         " of ", $self->{steps}, " executed\n" );

      if ( $self->{count} == $self->{steps} ) {
         $self->{count} = 0;
         print( "FOO: wait on semaphore ", $self->{taskSem}, "\n" );
         Tosf::Table::SEMAPHORE->wait( semaphore => $self->{taskSem} );
      }
      return ( "S0" );
   }

}

sub reset {
   my $self = shift @_;

   $self->{count} = 0;
   return ("S0");
}

1;
