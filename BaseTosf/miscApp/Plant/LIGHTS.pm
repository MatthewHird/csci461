package miscApp::Plant::LIGHTS;
#================================================================--
# File Name    : LIGHTS.pm
#
# Purpose      : Reaction Tester Lights
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
my $sensorLight;

sub leaveScript {
   main::leaveScript();
}


sub start {

   # create react window 

   my $reactWindow = new Gtk2::Window "toplevel";
   $reactWindow->set_title('Reaction Tester');
   $reactWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $reactWindow->set_resizable(FALSE);

   # create a react sensor and sensor light

   $sensorLight = Tosf::Widgit::Light->new(header => "Sensor");
   my $sensor = Tosf::Widgit::Sensor->new(
      markup => "<big> <big> Click Me </big> </big>",
      cb => sub {
         if (Tosf::Table::SVAR->get_value("sv_react")) {
            Tosf::Table::SVAR->assign("sv_react", 0);
            $sensorLight->set_light('white');
	 } else {
            Tosf::Table::SVAR->assign("sv_react", 1);
            $sensorLight->set_light('black');
         }
      }
   );

   # create vbox and place  react button  and light in vbox

   my $reactVbox = Gtk2::VBox->new( FALSE, 3 );
   $reactVbox->set_border_width(50);
   $reactVbox->pack_start($sensorLight->get_canvas(), FALSE, FALSE, 0);
   $reactVbox->pack_start($sensor->get_button(), FALSE, FALSE, 0);

   $reactWindow->add($reactVbox);

   # create ststus window

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

   # initialize status and sensor lights

   $red->set_light('red');
   $amber->set_light('gray');
   $green->set_light('green');
   $sensorLight->set_light('white');

   $statusWindow->show_all;
   $reactWindow->show_all;

}

 sub set_lights {
   my $class = shift @_;
   my @params = @_;

   $red->set_light($params[0]);
   $amber->set_light($params[1]);
   $green->set_light($params[2]);
}

1;
