package Tosf::Widgit::Light;
#================================================================--
# File Name    : Light.pm
#
# Purpose      : implements a single  light
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

use constant PI => 3.1415926;

#####################

sub new {
   my $class=shift @_;
   my %params=@_;

   my $self = {
      width => 200,
      height => 200,
      header => "Untitled",
      canvas => undef,
      text => undef,
      title => undef,
      light => undef,
      box => undef,
   };

   if (defined($params{width})) {
      $self->{width}=$params{width};
   }
   if (defined($params{height})) {
      $self->{height}=$params{height};
   }
   if (defined($params{header})) {
      $self->{header}=$params{header};
   }

   $self->{canvas} = Gnome2::Canvas->new_aa();
   $self->{canvas}->set_size_request($self->{width},$self->{height});
   $self->{canvas}->set_scroll_region( 0, 0, $self->{width}, $self->{height});   
   #to get upper left corner

   my $root = $self->{canvas}->root();

   $self->{text} = Gnome2::Canvas::Item->new(
      $root, 'Gnome2::Canvas::Text',
      x          => $self->{width} / 2,
      y          => $self->{height} * .50,
      fill_color => 'black',
      font       => 'Sans 14',
      anchor     => 'GTK_ANCHOR_CENTER',
      #text       =>  ($self->{max} / 2)
   );

   $self->{title} = Gnome2::Canvas::Item->new(
      $root, 'Gnome2::Canvas::Text',
      x          => $self->{width} / 2,
      y          => $self->{height} * .10,
      fill_color => 'black',
      font       => 'Sans 14',
      anchor     => 'GTK_ANCHOR_CENTER',
      text       => $self->{header}
   );


   $self->{box} = Gnome2::Canvas::Item->new(
      $root, 'Gnome2::Canvas::Rect',
      x1            => 0,
      y1            => 0,
      x2            => $self->{width},
      y2            => $self->{height},
      fill_color    => 'blue',
      outline_color => 'black'
   );

  $self->{light} = Gnome2::Canvas::Item->new(
      $root, "Gnome2::Canvas::Ellipse",
      x1            => 0 ,
      y1            => 0 ,
      x2            => $self->{width} ,
      y2            => $self->{height} ,
      outline_color => 'black',
      fill_color    => 'white'
   );

   $self->{box}->lower_to_bottom;
   #$self->{title}->raise($self->{light}); # text is written over light
   #$self->{text}->raise($self->{light}); # text is written over light

   bless ($self, $class);

   return $self;
}

sub get_canvas {
   my $self = shift @_;

   return $self->{canvas};
}

sub set_light {
   my $self = shift @_;
   my $value = shift @_;

   $self->{light}->set( fill_color => $value);
}

1;
