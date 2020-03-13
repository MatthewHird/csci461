package Tosf::Record::Iface;
#================================================================--
# File Name    : Record/Iface.pm
#
# Purpose      : implements interface control record 
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
      opened => my $opened = 0,
      heartbeatCount => my $heartbeatCount = 0,
      heartbeatFlag => my $heartbeatFlag = 1,
      dropFlag => my $dropFlag = 0,
      duplicateFlag => my $dublicateFlag = 0,
      line => Tosf::Collection::Line->new()
   };
                
   bless ($self, $class);
   return $self;
}

sub set_heartbeatCount {
   my $self = shift @_;
   my $i = shift @_;

   $self->{heartbeatCount} = $i;

   return;
}

 sub increment_heartbeatCount {
   my $self = shift @_;

   $self->{heartbeatCount} = ($self->{heartbeatCount} + 1) % 255;
   if ($self->{heartbeatCount} == 0) {
      $self->{heartbeatCount} = 1;
   }

   return;
}

sub get_hearbeatCount {
   my $self = shift @_;

   return $self->{heartbeatCount};
}

sub get_duplicateFlag {
   my $self = shift @_;

   return $self->{duplicateFlag};
}

sub set_duplicateFlag {
   my $self = shift @_;
   my $f = shift @_;

   $self->{duplicateFlag} = $f;
   return;
}

sub get_dropFlag {
   my $self = shift @_;

   return $self->{dropFlag};
}

sub set_dropFlag {
   my $self = shift @_;
   my $f = shift @_;

   $self->{dropFlag} = $f;
   return;
}

sub get_heartbeatFlag {
   my $self = shift @_;

   return $self->{heartbeatFlag};
}

sub set_heartbeatFlag {
   my $self = shift @_;
   my $f = shift @_;

   $self->{heartbeatFlag} = $f;
   return;
}

sub set_inLeftFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_inLeftFrame($f);
}

sub set_inRightFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_inRightFrame($f);
}

sub set_outRightFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_outRightFrame($f);
}

sub set_outLeftFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{line}->set_outLeftFrame($f);
}

sub get_opened {
   my $self = shift @_;

   return $self->{opened};
}

sub set_opened {
   my $self = shift @_;
   my $o = shift @_;

   $self->{opened} = $o;
   return;
}

sub dequeue_packet {
   my $self = shift @_;

   return $self->{line}->dequeue_packet();
}

sub dequeue_packet_fragment {
   my $self = shift @_;
   my $s = shift @_;

   return ($self->{line})->dequeue_packet_fragment($s);
}

sub flush {
   my $self = shift @_;
 
   $self->{line}->flush();
   return;
}

sub enqueue_packet {
   my $self = shift @_;
   my $p = shift @_;
 
   $self->{line}->enqueue_packet($p);
   return;
}

sub enqueue_packet_fragment {
   my $self = shift @_;
   my $f = shift @_;
 
   $self->{line}->enqueue_packet_fragment($f);
   return;
}

sub dump {
   my $self = shift @_;

   print ("Opened: $self->{opened} \n");
   print ("Heartbeat Flag: $self->{heartbeatFlag} \n");
   print ("Heartbeat Count: $self->{heartbeatCount} \n");
   print ("Drop Flag: $self->{dropFlag} \n");
   print ("Duplicate Flag: $self->{duplicateFlag} \n");
   print ("Line: \n");
   $self->{line}->dump();
}

1;
