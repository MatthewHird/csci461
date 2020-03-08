package Tosf::Widgit::Sensor;
#================================================================--
# File Name    : Sensor.pm
#
# Purpose      : implements a single sensor (aka button) 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 0.1          PW      Sept 2017   New version
#=========================================================

$|=1;

use strict;
use warnings;

#####################

sub new {
   my $class=shift @_;
   my %params=@_;
   
   my $self = {
      button => Gtk2::Button->new(),
      cb => $params{cb}
   };

   if (defined($params{markup})) {
      my $label = Gtk2::Label->new();
   
      $label->set_markup($params{markup});
      $self->{button}->add($label);
   }

   if (defined($params{cb})) {
      $self->{button}->signal_connect( clicked => $self->{cb});
   }

   bless ($self, $class);

   return $self;
}

sub get_button {
   my $self = shift @_;

   return $self->{button};
}


1;
