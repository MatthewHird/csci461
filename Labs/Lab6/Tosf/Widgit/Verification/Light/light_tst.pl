#!/usr/bin/perl
######################################################
# Peter Walsh
# light test driver
######################################################

$|=1;

use strict;
use warnings;
use lib '../../../../';
use Try::Tiny;
use Tosf::Widgit::Light;
use AnyEvent;
use Gtk2 -init;
use Gnome2::Canvas; 

use constant FALSE => 0;
use constant TRUE => 1;

sub leaveScript {
   print("Shutdown Now !!!!! \n");
   exit();
}

my $light;
my $state = 0;

my $d = AnyEvent->timer(
   after => 3,
   interval => 3,
   cb => sub { 
      if ($state == 0) {
         $light->set_light('red'); 
         $state = 1;
      } elsif ($state == 1) {
         $light->set_light('yellow'); 
         $state = 2;
      } elsif ($state == 2) {
         $light->set_light('green'); 
         $state = 3;
      } elsif ($state == 3) {
         $light->set_light('gray'); 
         $state = 0;
      }
   }
);


 ############################################
   # create highway window

   my $window = new Gtk2::Window "toplevel";
   $window->set_title('light_tst');
   $window->set_resizable(FALSE);
   $window->signal_connect( 'destroy' => sub {leaveScript();});

   ##########################################
   # create  a light

   $light = Tosf::Widgit::Light->new(header => "Light");


   ##########################################
   # create hbox and place   light  in hbox
   my $hbox = Gtk2::HBox->new( FALSE, 6 );
   $hbox->pack_start($light->get_canvas(),FALSE,FALSE,0);
   $window->add($hbox);

   ##########################################
   # set light

   $window->show_all;

   main Gtk2;
