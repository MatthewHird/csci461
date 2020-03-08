package Tosf::Exception::Trap;
#================================================================--
# Design Unit  : trap module
#
# File Name    : /Trap.pm
#
# Purpose      : implements trap service routines
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
   my $class = shift @_;
   my %params = @_;

   my $self = {
      name => 'no name',
      description => 'no description'
   };

   if (defined($params{name})) {
      $self->{name} = $params{name};
   } 

   if (defined($params{description})) {
      $self->{description} = $params{description};
   }

   bless ($self, $class);

   return $self;
}

sub get_name {
   my $self = shift @_;

    return $self->{name};
}

sub set_name {
   my $self = shift @_;
   my $val = shift @_;

   $self->{name} = $val;

   return 0;
}

sub get_description {
   my $self = shift @_;

    return $self->{description};
}

sub set_description {
   my $self = shift @_;
   my $val = shift @_;

   $self->{description} = $val;

   return 0;
}

1;
