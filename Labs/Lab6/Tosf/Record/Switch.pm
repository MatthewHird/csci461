package Tosf::Record::Switch;
#================================================================--
# File Name    : Switch.pm
#
# Purpose      : implements Switch record
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

sub  new {
   my $class = shift @_;

   my $self = {
      iface => my $iface = 'noname',
      time => my $time = 40
   };
                
   bless ($self, $class);
   return $self;
}

sub get_iface {
   my $self = shift @_;
   
   return $self->{iface};
}

sub set_iface {
   my $self = shift @_;
   my $d = shift @_;
 
   $self->{iface} = $d;
   return;
}

sub get_time {
   my $self = shift @_;
   
   return $self->{time};
}

sub set_time {
   my $self = shift @_;
   my $t = shift @_;
 
   $self->{time} = $t;
   return;
}

sub dumps {
   my $self = shift @_;

   my $s = '';

   $s = $s . "Interface (port): $self->{iface} ";
   $s = $s . "Time: $self->{time} ";

   return $s;
}


sub dump {
   my $self = shift @_;

   print ("Interface (port): $self->{iface} \n");
   print ("Time: $self->{time} \n");
   return;
}

1;
