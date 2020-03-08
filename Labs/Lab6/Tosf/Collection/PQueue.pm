package Tosf::Collection::PQueue;
#================================================================--
# File Name    : PQueue.pm
#
# Purpose      : implements priority queue ADT
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant VALUE => 0;
use constant PRIORITY => 1;
use constant NEXT => 2;

sub  new {
   my $class = shift @_;

   my $self = {
      head => my $head,
      siz => my $siz
   };

   $self->{head} = ["dummy", -1 ,undef];
   $self->{siz} = 0;
                
   bless ($self, $class);

   return $self;
}

sub enqueue {
   my $self = shift @_;
   my $value = shift @_;
   my $priority = shift @_;


   if (!defined($value)) {
      die(Tosf::Exception::Trap->new(name => "novalue"));
   }

   if (!defined($priority)) {
      die(Tosf::Exception::Trap->new(name => "nopriority"));
   }

   my $ptr = $self->{head};
   my $previous = undef;

   while (defined($ptr) && $priority >= $ptr->[PRIORITY]) {
      $previous = $ptr;
      $ptr = $ptr->[NEXT];
   }

   my $node = [$value, $priority, $ptr];
   $previous->[NEXT] = $node;
   $self->{siz} = $self->{siz} + 1;

   return;
}

sub dequeue {
   my $self = shift @_;

   my $rval = undef;

   if ($self->{siz} > 0) {
      $rval = $self->{head}->[NEXT]->[VALUE];
      # skip the dummy
      $self->{head}->[NEXT] = $self->{head}->[NEXT]->[NEXT];
      # dequeued node gets returned to memory when it is
      # no longer referenced
      $self->{siz} = $self->{siz} - 1;
   }
   
   return $rval;

}
   
sub get_siz {
   my $self = shift @_;

   return ($self->{siz});
}

sub dump {
   my $self = shift @_;

   my $x = $self->{head};

   while (defined($x))  {
	
      print( $x->[VALUE], " ", $x->[PRIORITY], "\n");
      $x=$x->[NEXT];
	      
   }
}

1;
