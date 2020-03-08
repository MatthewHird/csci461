package Tosf::Collection::Line;
#================================================================--
# File Name    : Line.pm
#
# Purpose      : implements wired line framing and queueing 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;
use strict;
use warnings;

sub  new {
   my $class = shift @_;
   my %params = @_;

   my $self = {
      maxbuff => my $maxbuff = 10000,
      inbuff => my $inbuff = '',
      outbuff => my $outbuff = '',
      inLeftFrame => my $inLftFrame = '_G_',
      inRightFrame => my $inRightFrame = '_H_',
      outLeftFrame => my $outLftFrame = '_G_',
      outRightFrame => my $outRightFrame = '_H_',
      outSepSize => my $outSepSize
   };

   if (defined($params{maxbuff})) {
      $self->{maxbuff} = $params{maxbuff};
   }

   if (defined($params{inLeftFrame})) {
      $self->{inLeftFrame} = $params{inLeftFrame};
   }

   if (defined($params{inRightFrame})) {
      $self->{inRightFrame} = $params{inRightFrame};
   }

   if (defined($params{outLeftFrame})) {
      $self->{outLeftFrame} = $params{outLeftFrame};
   }

   if (defined($params{outRightFrame})) {
      $self->{outRightFrame} = $params{outRightFrame};
   }

   $self->{outSepSize} = (length($self->{outLeftFrame}) + length($self->{outRightFrame}));

   bless ($self, $class);
   return $self;
}

sub set_inRightFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{inRightFrame} = $f;

   return;
}

sub get_inRightFrame {
   my $self = shift @_;

   return $self->{inRightFrame};
}

sub set_outRightFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{outRightFrame} = $f;

   return;
}

sub get_outRightFrame {
   my $self = shift @_;

   return $self->{outRightFrame};
}

sub set_inLeftFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{inLeftFrame} = $f;

   return;
}

sub get_inLeftFrame {
   my $self = shift @_;

   return $self->{inLeftFrame};
}

sub set_outLeftFrame {
   my $self = shift @_;
   my $f = shift @_;

   $self->{outLeftFrame} = $f;

   return;
}

sub get_outLeftFrame {
   my $self = shift @_;

   return $self->{outLeftFrame};
}

sub dequeue_packet {
   my $self = shift @_;

   my $hold = undef;

   # regex is prototype code... needs to be optimized
   my $pattern = $self->{inLeftFrame} . ".*?". $self->{inRightFrame};

   $self->{inbuff} =~ s/$pattern//;
   if (defined($')) {
      $self->{inbuff} = $'; # remove any garbage before the pkt
      $hold = $&;

      if ($self->{inLeftFrame} ne '') {
         $hold =~ s/$self->{inLeftFrame}//g;
      }

      if ($self->{inRightFrame} ne '') {
         $hold =~ s/$self->{inRightFrame}//g;
      }
   } 

   return $hold;
}

sub enqueue_packet {
   my $self = shift @_;
   my $msg = shift @_;

   if ((length($self->{outbuff}) + length($msg) + $self->{outSepSize}) > ($self->{maxbuff})) {
      die(Tosf::Exception::Trap->new(name => "fullbuff"));
   }

   $self->{outbuff} = $self->{outbuff} . $self->{outLeftFrame} . $msg . $self->{outRightFrame};

   return;
}

sub enqueue_packet_fragment {
   my $self = shift @_;
   my $chunk = shift @_;

   if ((length($self->{inbuff}) + length($chunk)) > ($self->{maxbuff})) {
      die(Tosf::Exception::Trap->new(name => "fullbuff"));
   }

   my $l;
   $l = length($self->{inbuff});

   $self->{inbuff} = $self->{inbuff} . $chunk;

   # regex is prototype code... needs to be optimized
   # my $pattern = $self->{inLeftFrame} . "heartbeat". $self->{inRightFrame};
   # $self->{inbuff} =~ s/$pattern//g;

   return;
}

sub dequeue_packet_fragment {
   my $self = shift @_;
   my $siz = shift @_;

   if (!defined($siz)) {
      $siz=30;
   }

   my $len = length($self->{outbuff});
   if ($len == 0) {
      return undef;
   } else {
      if ($len < $siz) {
         $siz = $len;
      }

      # propbems with \r as part of the string
      #$self->{outbuff} =~ s/.{$siz,$siz}//;
      #return $&;
      
      my $y = substr($self->{outbuff}, 0, $siz, "");

      return $y;
   }
}

sub get_outbuff_size {
   my $self = shift @_;

   return length($self->{outbuff});
}

sub flush {
   my $self = shift @_;

   $self->{outbuff} = '';
   $self->{inbuff} = '';
}

sub flushOutbuff {
   my $self = shift @_;

   $self->{outbuff} = '';
}

sub flushInbuff {
   my $self = shift @_;

   $self->{inbuff} = '';
}

sub dump {
   my $self = shift @_;

   print "MAXBUFF $self->{maxbuff}\n";
   print "IN LEFT FRAME $self->{inLeftFrame}\n";
   print "IN RIGHT FRAME $self->{inRightFrame}\n";
   print "OUT LEFT FRAME $self->{outLeftFrame}\n";
   print "OUT RIGHT FRAME $self->{outRightFrame}\n";
   print "OUT SEP SIZE $self->{outSepSize}\n";
   print "INBUFF->$self->{inbuff}<-\n";
   print "OUTBUFF->$self->{outbuff}<-\n";

   return 1;
}

1;
