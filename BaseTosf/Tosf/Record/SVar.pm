package Tosf::Record::SVar;
#================================================================--
# File Name    : SVar.pm
#
# Purpose      : implements shared variable record
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my $value = ' ';
my $nextValue = 0;

sub  new {
   my $class = shift @_;
   my %params = @_;

   if (defined($params{value})) {
      $value = $params{value};
   }

   if (defined($params{nextValue})) {
      $nextValue = $params{nextValue};
   }

   my $self = {
      value => $value,
      nextValue => $nextValue
   };
                
   bless ($self, $class);
   return $self;
}

sub get_value {
   my $self = shift @_;
   
   return $self->{value};
}

sub set_value {
   my $self = shift @_;
   my $v = shift @_;
 
   $self->{value} = $v;
   return;
}

sub get_nextValue	 {
   my $self = shift @_;
   
   return $self->{nextValue};
}

sub set_nextValue {
   my $self = shift @_;
   my $v = shift @_;
 
   $self->{nextValue} = $v;
   return;
}

sub assign {
   my $self = shift @_;
   my $v = shift @_;
 
   $self->{nextValue} = $v;
   return;
}

sub update {
   my $self = shift @_;

   $self->{value} = $self->{nextValue};

   return;
}

sub dump {
   my $self = shift @_;

   print ("Current Value: $self->{value} \n");
   print ("Next value: $self->{nextValue} \n");
   return;
}

1;
