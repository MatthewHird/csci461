package Tosf::Demo::Lifo;
#================================================================--
# File Name    : Lifo.pm
#
# Purpose      : implements LIFO (stack) adt
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 0.1          PW      Oct 1   New version
# 0.2          PW      Oct 12  move empty and full flag-exceptions
#                              to an proper exception class
#=========================================================

$|=1;
use strict;
use warnings;

sub new {
   my $class = shift @_;
   my %params = @_;

   my $self = {maxsiz => 5,
               stack => []
              };

   if (defined($params{max})) {
      $self->{maxsiz} = $params{max};
   }

   bless ($self, $class);

   return $self;
}


sub size {
   my $self = shift @_;

   return scalar  @{$self->{stack}};
}

sub push {
   my $self = shift @_;
   my $val = shift @_;

   if ($self->size() == $self->{maxsiz}) {
      die(Tosf::Exception::Trap->new(name => "full"));
   }

   push (@{$self->{stack}}, $val);

   return 0;

}

sub pop {
   my $self = shift @_;

   if ($self->size() == 0) {
      die(Tosf::Exception::Trap->new(name => "empty"));
   }

   pop (@{$self->{stack}});

   return 0;
}


sub top {
   my $self = shift @_;

   if ($self->size() == 0) {
      die(Tosf::Exception::Trap->new(name => "empty"));
   }

   return ${$self->{stack}}[$self->size()-1];
}

# for interactive testing only

sub dump {
   my $self = shift @_;
   
   print ("Stack Dump\n");
   for (my $i = 0; $i < $self->size(); $i++) {
      print (${$self->{stack}}[$i], "\n");
   }

   return 0;
}

1;
