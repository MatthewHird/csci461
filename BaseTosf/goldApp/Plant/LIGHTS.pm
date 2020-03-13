package goldApp::Plant::LIGHTS;
#================================================================--
# File Name    : LIGHTS.pm
#
# Purpose      : GUI Client Goldberg physical plant
#                (sensor/actuator)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

use strict;
use warnings;
use Tosf::Widgit::Light;
use Tosf::Widgit::Sensor;
use Tosf::Table::SVAR;

use constant FALSE => 0;
use constant TRUE => 1;

my $red;
my $amber;
my $green;
my $regLight;
my $stopLight;

sub leaveScript {
   main::leaveScript();
}


sub start {

   # create reg window 

   my $regWindow = new Gtk2::Window "toplevel";
   $regWindow->set_title('Goldberg Client');
   $regWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $regWindow->set_resizable(FALSE);

   # create a reg button and reg light

   $regLight = Tosf::Widgit::Light->new(header => "Sensor");
   my $reg = Tosf::Widgit::Sensor->new(
      markup => "<big> <big> Click Me To Register</big> </big>",
      cb => sub {
         Tosf::Table::SVAR->assign("sv_regReq", 1);
         $regLight->set_light('black');
      }
   );

   # create vbox and place  reg button  and light in vbox

   my $regVbox = Gtk2::VBox->new( FALSE, 3 );
   $regVbox->set_border_width(50);
   $regVbox->pack_start($regLight->get_canvas(), FALSE, FALSE, 0);
   $regVbox->pack_start($reg->get_button(), FALSE, FALSE, 0);

   $regWindow->add($regVbox);

   #===============================================================
   
   # create stop window 

   my $stopWindow = new Gtk2::Window "toplevel";
   $stopWindow->set_title('Goldberg Client');
   $stopWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $stopWindow->set_resizable(FALSE);

   # create a stop button and stop light

   $stopLight = Tosf::Widgit::Light->new(header => "Sensor");
   my $stop = Tosf::Widgit::Sensor->new(
      markup => "<big> <big> Click Me To Stop Machine</big> </big>",
      cb => sub {
         Tosf::Table::SVAR->assign("sv_stop", 1);
         $stopLight->set_light('black');
      }
   );

   # create vbox and place  stop button  and light in vbox

   my $stopVbox = Gtk2::VBox->new( FALSE, 3 );
   $stopVbox->set_border_width(50);
   $stopVbox->pack_start($stopLight->get_canvas(), FALSE, FALSE, 0);
   $stopVbox->pack_start($stop->get_button(), FALSE, FALSE, 0);

   $stopWindow->add($stopVbox);

   #===============================================================
   
   # create status window

   my $statusWindow = new Gtk2::Window "toplevel";
   $statusWindow->set_title('Status');
   $statusWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $statusWindow->set_resizable(FALSE);

   # create  status lights

   $red = Tosf::Widgit::Light->new(header => "Red");
   $green = Tosf::Widgit::Light->new(header => "Green");
   $amber = Tosf::Widgit::Light->new(header => "Amber");

   # create vbox and place  status lights  in vbox

   my $statusVbox = Gtk2::VBox->new( FALSE, 3 );
   $statusVbox->pack_start($red->get_canvas(),FALSE,FALSE,0);
   $statusVbox->pack_start($amber->get_canvas(),FALSE,FALSE,0);
   $statusVbox->pack_start($green->get_canvas(),FALSE,FALSE,0);
   $statusWindow->add($statusVbox);

   # initialize status and button lights

   $red->set_light('red');
   $amber->set_light('gray');
   $green->set_light('green');
   $regLight->set_light('white');
   $stopLight->set_light('white');

   $statusWindow->show_all;
   $regWindow->show_all;
   $stopWindow->show_all;

}

 sub set_buttons {
   my $class = shift @_;
   my @params = @_;
   $regLight->set_light($params[0]);
   $stopLight->set_light($params[1]);
}


 sub set_lights {
   my $class = shift @_;
   my @params = @_;

   $red->set_light($params[0]);
   $amber->set_light($params[1]);
   $green->set_light($params[2]);
}

1;
