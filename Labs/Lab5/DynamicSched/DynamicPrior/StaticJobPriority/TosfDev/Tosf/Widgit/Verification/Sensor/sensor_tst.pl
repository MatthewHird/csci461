#!/usr/bin/perl
######################################################
# Peter Walsh
# sensor test driver
######################################################

$|=1;

use strict;
use warnings;
use lib '../../../../';
use Try::Tiny;
use Tosf::Widgit::Sensor;
use Gtk2 -init;
use constant FALSE => 0;
use constant TRUE => 1;

sub leaveScript {
   print("Shutdown Now !!!!! \n");
   exit();
}

 ############################################
   # create sensor window

   my $window = new Gtk2::Window "toplevel";
   $window->set_title('sensor_tst');
   $window->set_resizable(FALSE);
   $window->signal_connect( 'destroy' => sub {leaveScript();});

   ##########################################
   # create  a sensor

   my $sensor = Tosf::Widgit::Sensor->new(
      markup => "<big> <big> Click Me </big> </big>",
      cb => sub {
         print("clicked\n");
      }
   );


   ##########################################
   # create vbox and place   sensor  in vbox
   
   my $Vbox = Gtk2::VBox->new( FALSE, 3 );
   $Vbox->set_border_width(50);
   $Vbox->pack_start($sensor->get_button(), FALSE, FALSE, 0);
   $window->add($Vbox);

   ##########################################
   # set sensor

   $window->show_all;

   main Gtk2;
