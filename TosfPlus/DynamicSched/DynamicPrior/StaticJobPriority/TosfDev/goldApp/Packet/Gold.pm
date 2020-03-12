package goldApp::Packet::Gold;
#================================================================--
# File Name    : Packet/Gold.pm
#
# Purpose      : implements Gold packet ADT
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use constant PCHAR => '_R_';

sub  new {
   my $class = shift @_;
   my $name = shift @_;

   my $self = {
      src_mac => my $scr_mac = 'none',
      dest_mac => my $dest_mac = 'none',
      opcode => my $opcode = ' ',
      err => my $err = ' ',
      msg => my $msg = ' '
   };

   bless ($self, $class);

   return $self;
}

sub get_srcMac {
   my $self = shift @_;
   
   return $self->{src_mac};
}

sub set_srcMac {
   my $self = shift @_;
   my $m = shift @_;
 
   if (defined($m)) {
      $self->{src_mac} = $m;
   }

   return;
}

sub get_destMac {
   my $self = shift @_;
   
   return $self->{dest_mac};
}

sub set_destMac {
   my $self = shift @_;
   my $m = shift @_;
 
   if (defined($m)) {
      $self->{dest_mac} = $m;
   }

   return;
}

sub set_opcode {
   my $self = shift @_;
   my $ph = shift @_;
 
   if (defined($ph)) {
      $self->{opcode} = $ph;
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

sub set_err {
   my $self = shift @_;
   my $m = shift @_;
 
   if (defined($m)) {
      $self->{err} = $m;
   }

   return;
}

sub get_err {
   my $self = shift @_;

   return $self->{err};
}

sub encode {
   my $self = shift @_;

   my @m;

   $m[0] = $self->{src_mac};
   $m[1] = $self->{dest_mac};
   $m[2] = $self->{opcode};
   $m[3] = $self->{err};
   $m[4] = $self->{msg};

   return join(PCHAR, @m);
}

sub decode {
   my $self = shift @_;
   my $pkt = shift @_;

   my @m = split(PCHAR, $pkt);

   $self->{src_mac} = $m[0];
   $self->{dest_mac} = $m[1];
   $self->{opcode} = $m[2];
   $self->{err} = $m[3];
   $self->{msg} = $m[4];

   return;
}

sub dump {
   my $self = shift @_;

   print ("SRC MAC: $self->{src_mac} \n");
   print ("DEST MAC: $self->{dest_mac} \n");
   print ("OPCODE: $self->{opcode} \n");
   print ("ERR: $self->{err} \n");
   print ("MSG: $self->{msg} \n");

   return;
}

1;
