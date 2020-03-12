package Tosf::Packet::Work;
#================================================================--
# File Name    : Packet/Work.pm
#
# Purpose      : implements Work packet ADT
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use constant PCHAR => '_N_';


sub  new {
   my $class = shift @_;
   my $name = shift @_;

   my $self = {
      opcode => my $opcode = ' ',
      iface => my $iface = ' ',
      par => my $par = ' ',
      msg => my $msg = ' '
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
   my $i = shift @_;
 
   if (defined($i)) {
      $self->{iface} = $i;
   }

   return;
}

sub get_par {
   my $self = shift @_;
   
   return $self->{par};
}

sub set_par {
   my $self = shift @_;
   my $p = shift @_;
 
   if (defined($p)) {
      $self->{par} = $p;
   }

   return;
}

sub set_opcode {
   my $self = shift @_;
   my $o = shift @_;
 
   if (defined($o)) {
      $self->{opcode} = $o;
   }

   return;
}

sub get_opcode {
   my $self = shift @_;

   return $self->{opcode};
}

sub set_msg {
   my $self = shift @_;
   my $m = shift @_;
 
   if (defined($m)) {
      $self->{msg} = $m;
   }

   return;
}

sub get_msg {
   my $self = shift @_;

   return $self->{msg};
}

sub encode {
   my $self = shift @_;

   my @m;

   $m[0] = $self->{opcode};
   $m[1] = $self->{iface};
   $m[2] = $self->{par};
   $m[3] = $self->{msg};

   return join(PCHAR, @m);
}

sub decode {
   my $self = shift @_;
   my $pkt = shift @_;

   my @m = split(PCHAR, $pkt);

   $self->{opcode} = $m[0];
   $self->{iface} = $m[1];
   $self->{par} = $m[2];
   $self->{msg} = $m[3];

   return;
}

sub dump {
   my $self = shift @_;

   print ("OPCODE: $self->{opcode} \n");
   print ("IFACE: $self->{iface} \n");
   print ("PARAMS: $self->{par} \n");
   print ("MSG: $self->{msg} \n");

   return;
}

1;
