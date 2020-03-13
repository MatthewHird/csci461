package Tosf::Exception::Monitor;
#================================================================--
# File Name    : Monitor.pm
#
# Purpose      : Wrap generic try/catch blocks around a function
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
no warnings "experimental::smartmatch";

use Try::Tiny;

sub new {
   my $class = shift @_;
   my %params = @_;

   my $self = {
      fn => ' '
   };

   $self->{fn} = $params{fn};

   bless ($self, $class);

   return $self;
}

sub run {
   my $self = shift @_;

   try {
      $self->{fn}->(); 
   }

   catch {
      my $cew_e = $_;
      if (ref($cew_e) ~~ "Tosf::Exception::Trap") {
         my $exc_name = $cew_e->get_name();
         my $exc_description = $cew_e->get_description();
         print("FATAL ERROR (ty1): $exc_name  *** $exc_description\n");
      } else {
         print("FATAL ERROR (ty2): $cew_e");
      }

      main::leaveScript(20);
   }
}   

1;
