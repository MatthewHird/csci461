package traceApp::Fsm::JERRY;

#================================================================--
# File Name    : JERRY.pm
#
# Purpose      : implements task JERRY (to demonstrate
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
      taskSem  => my $taskSem
   };

   if ( defined( $params{taskName} ) ) {
      $self->{taskName} = $params{taskName};
   }
   else {
      die(
         Tosf::Exception::Trap->new( name => "Task::JERRY taskName undefined" )
      );
   }

   if ( defined( $params{taskSem} ) ) {
      $self->{taskSem} = $params{taskSem};
   }
   else {
      die( Tosf::Exception::Trap->new( name => "Task::JERRY taskSem undefined" )
      );
   }

   bless( $self, $class );
   return $self;
}

my $count;

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
      $count = $count + 1;
      print("JERRY called $count times \n");
      print( "JERRY: wait on semaphore ", $self->{taskSem}, "\n" );
      Tosf::Table::SEMAPHORE->wait( semaphore => $self->{taskSem} );
      return ( "S1" );
   }

}

sub reset {
   my $self = shift @_;

   $count = 0;
   return ("S1");
}

1;
