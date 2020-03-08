package goldApp::Packet::Params;
#================================================================--
# File Name    : Packet/Link.pm
#
# Purpose      : implements Params packet ADT
#               TEMPLATE
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use constant PCHAR => '_P_';


sub  new {
   my $class = shift @_;
   my $name = shift @_;

   my $self = {
      p1 => my $p1 = 'none'
   };

   bless ($self, $class);

   return $self;
}

sub get_p1 {
   my $self = shift @_;
   
   return $self->{p1};
}

sub set_p1 {
   my $self = shift @_;
   my $i = shift @_;
 
   if (defined($i)) {
      $self->{p1} = $i;
   }

   return;
}

sub encode {
   my $self = shift @_;

   my @m;

   $m[0] = $self->{p1};

   return join(PCHAR, @m);
}

sub decode {
   my $self = shift @_;
   my $pkt = shift @_;

   my @m = split(PCHAR, $pkt);

   $self->{p1} = $m[0];

   return;
}

sub dump {
   my $self = shift @_;

   print ("IFACE: $self->{p1} \n");

   return;
}

1;
