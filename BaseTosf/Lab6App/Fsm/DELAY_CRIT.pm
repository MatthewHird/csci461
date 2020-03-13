package Lab6App::Fsm::DELAY_CRIT;

#==================================================================--
# File Name      : DELAY_CRIT.pm
#
# Purpose        :
#
# Author         : Matthew Hird
#
# System         : Perl (Linux)
#
#==================================================================

$| = 1;
use strict;
use warnings;

sub new {
   my $class  = shift @_;
   my %params = @_;

   my $self = {
      taskName    => my $taskName,
      taskSem     => my $taskSem,
      delayLength => my $delayLength,
      critLength  => my $critLength,
      delayCount  => 0,
      critCount   => 0
   };

   if ( defined( $params{taskName} ) ) {
      $self->{taskName} = $params{taskName};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Task::DELAY_CRIT taskName undefined"
         )
      );
   }

   if ( defined( $params{taskSem} ) ) {
      $self->{taskSem} = $params{taskSem};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Task::DELAY_CRIT taskSem undefined"
         )
      );
   }

   if ( defined( $params{delayLength} ) ) {
      $self->{delayLength} = $params{delayLength};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Task::DELAY_CRIT delayLength undefined"
         )
      );
   }

   if ( defined( $params{critLength} ) ) {
      $self->{critLength} = $params{critLength};
   }
   else {
      die(
         Tosf::Exception::Trap->new(
            name => "Task::DELAY_CRIT critLength undefined"
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

      my $state;
      if ( $self->{delayCount} < $self->{delayLength} ) {
         $self->{delayCount} = $self->{delayCount} + 1;
         $state = "S0";

         print(
            "DELAY_CRIT: Task ",
            $self->{taskName}, " -> delay section ",
            $self->{delayCount}, " of ", $self->{delayLength}, " executed\n"
         );
      }
      else {
         $self->{delayCount} = 0;
         $state = "S1";

         print( $self->{taskName}, ": wait on mutex\n" );
         Tosf::Table::SEMAPHORE->wait( semaphore => "mutex" );
      }
      return ( $state );
   }

   if ( $mmt_currentState ~~ "S1" ) {
      print( "Resume Time: ",
         Tosf::Table::TASK->get_resumeTime( $self->{taskName} ), ";\n" );
      my $state;
      if ( $self->{critCount} < $self->{critLength} - 1 ) {
         $self->{critCount} = $self->{critCount} + 1;
         $state = "S1";

         print(
            "DELAY_CRIT: Task ",
            $self->{taskName},
            " -> crit section (mutex) ",
            $self->{critCount},
            " of ",
            $self->{critLength},
            " executed\n"
         );
      }
      else {
         $self->{critCount} = 0;
         $state = "S0";

         print(
            "DELAY_CRIT: Task ",
            $self->{taskName},
            " -> crit section (mutex) ",
            $self->{critLength},
            " of ",
            $self->{critLength},
            " executed\n"
         );

         print( $self->{taskName}, ": signal semaphore mutex\n" );
         Tosf::Table::SEMAPHORE->signal(
            semaphore => "mutex",
            task      => $self->{taskName}
         );
         print( "DELAY_CRIT: wait on semaphore ", $self->{taskSem}, "\n" );
         Tosf::Table::SEMAPHORE->wait( semaphore => $self->{taskSem} );
      }
      return ( $state );
   }

}

sub reset {
   my $self = shift @_;

   return ("S0");
}

1;
