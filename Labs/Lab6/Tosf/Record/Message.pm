package Tosf::Record::Message;
#================================================================--
# File Name    : Message.pm
#
# Purpose      : implements Message record
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my $value = 0;
my $max = 1;

sub  new {
   my $class = shift @_;
   my %params = @_;

   if (defined($params{value})) {
      $value = $params{value};
   }

   if (defined($params{max})) {
      $max = $params{max};
   }

   my $self = {
      semaphore => Tosf::Record::Semaphore->new(
         value => $value, 
	 max =>  $max
      ),
      messageQueue => Tosf::Collection::Queue->new()
   };
                
   bless ($self, $class);
   return $self;
}

sub get_max {
   my $self = shift @_;
   
   return $self->{semaphore}->get_max();
}

sub set_max {
   my $self = shift @_;
   my $m = shift @_;
 
   $self->{semapgore}->set_max($m);
   return;
}

sub get_value	 {
   my $self = shift @_;
   
   return $self->{semaphore}->get_value();
}

sub set_value {
   my $self = shift @_;
   my $v = shift @_;
 
   $self->{semaphore}->set_value($v);
   return;
}

sub enqueue {
   my $self = shift @_;
   my $m = shift @_;

   $self->{messageQueue}->enqueue($m);

}

sub dequeue {
   my $self = shift @_;

   return $self->{messageQueue}->dequeue();
}

sub wait {
   my $self = shift @_;
   my $t = shift @_;

   $self->{semaphore}->wait($t);

   return;
}

sub signal {
   my $self = shift @_;

   $self->{semaphore}->signal();

   return;
}

sub dump {
   my $self = shift @_;

   print ("Semaphore: "); 
   $self->{semaphore}->dump();
   print(" \n");
   print ("Message Queue: ");
   $self->{messageQueue}->dump();
   print(" \n");
   return;
}

1;
