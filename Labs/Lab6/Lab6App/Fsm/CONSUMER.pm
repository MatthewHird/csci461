package Lab6App::Fsm::CONSUMER;

#================================================================--
# File Name    : CONSUMER.pm
#
# Purpose      : implements task CONSUMER (to demonstrate
#                producer/consumer problem).
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
         Tosf::Exception::Trap->new(
            name => "Task::CONSUMER taskName undefined"
         )
      );
   }

   if ( defined( $params{taskSem} ) ) {
      $self->{taskSem} = $params{taskSem};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Task::CONSUMER taskSem undefined"
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
      print( "CONSUMER task ", $self->{taskName}, " executing \n" );
      print( "CONSUMER task ", $self->{taskName}, " wait on full \n" );
      Tosf::Table::SEMAPHORE->wait( semaphore => "full" );
      return ( "S1" );
   }

   if ( $mmt_currentState ~~ "S1" ) {
      print( "CONSUMER task ", $self->{taskName}, " executing \n" );
      print( "CONSUMER task ", $self->{taskName}, " wait on mutex \n" );
      Tosf::Table::SEMAPHORE->wait( semaphore => "mutex" );
      return ( "S2" );
   }

   if ( $mmt_currentState ~~ "S2" ) {
      print( "CONSUMER task ", $self->{taskName}, " executing CONSUME\n" );

      print("CONSUMER: signal semaphore  mutex \n");
      Tosf::Table::SEMAPHORE->signal( semaphore => "mutex" );

      print("CONSUMER: signal semaphore  empty \n");
      Tosf::Table::SEMAPHORE->signal( semaphore => "empty" );
      return ( "S0" );
   }

}

sub reset {
   my $self = shift @_;

   print( "CONSUMER: signal semaphore ", $self->{taskSem}, " \n" );
   Tosf::Table::SEMAPHORE->signal( semaphore => $self->{taskSem} );
   return ("S0");
}

1;
