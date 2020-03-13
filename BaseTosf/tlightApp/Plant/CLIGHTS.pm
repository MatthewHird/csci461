package tlightApp::Plant::CLIGHTS;
#================================================================--
# File Name    : CLIGHTS.pm
#
# Purpose      : Centralized traffic light physical plant
#                (lights set up)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

use strict;
use warnings;

use constant FALSE => 0;
use constant TRUE => 1;

my $hwRed;
my $hwYellow;
my $hwGreen;
my $fyRed;
my $fyYellow;
my $fyGreen;
my $sensorLight;

sub leaveScript {
	main::leaveScript();
}


sub start {

   # create car window 

   my $carWindow = new Gtk2::Window "toplevel";
   $carWindow->set_title('Car');
   $carWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $carWindow->set_resizable(FALSE);

   # create a car sensor and sensor light

   $sensorLight = Tosf::Widgit::Light->new(header => "Sensor");
   my $sensor = Tosf::Widgit::Sensor->new(
      markup => "<big> <big> Click Me </big> </big>",
      cb => sub {
         if (Tosf::Table::SVAR->get_value("sv_car")) {
            Tosf::Table::SVAR->assign("sv_car", 0);
            $sensorLight->set_light('gray');
	 } else {
            Tosf::Table::SVAR->assign("sv_car", 1);
            $sensorLight->set_light('black');
         }
      }
   );

   # create vbox and place  car button  and light in vbox

   my $carVbox = Gtk2::VBox->new( FALSE, 3 );
   $carVbox->set_border_width(50);
   $carVbox->pack_start($sensorLight->get_canvas(), FALSE, FALSE, 0);
   $carVbox->pack_start($sensor->get_button(), FALSE, FALSE, 0);

   $carWindow->add($carVbox);

   # create highway window

   my $hwWindow = new Gtk2::Window "toplevel";
   $hwWindow->set_title('Highway');
   $hwWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $hwWindow->set_resizable(FALSE);

   # create  highway lights

   $hwRed = Tosf::Widgit::Light->new(header => "Red");
   $hwGreen = Tosf::Widgit::Light->new(header => "Green");
   $hwYellow = Tosf::Widgit::Light->new(header => "Amber");

   # create vbox and place  highway lights  in vbox

   my $hwVbox = Gtk2::VBox->new( FALSE, 3 );
   $hwVbox->pack_start($hwRed->get_canvas(),FALSE,FALSE,0);
   $hwVbox->pack_start($hwYellow->get_canvas(),FALSE,FALSE,0);
   $hwVbox->pack_start($hwGreen->get_canvas(),FALSE,FALSE,0);
   $hwWindow->add($hwVbox);

   # initialize highway and sensor lights

   $hwRed->set_light('gray');
   $hwYellow->set_light('gray');
   $hwGreen->set_light('green');
   $sensorLight->set_light('gray');

   # create farmyard window

   my $fyWindow = new Gtk2::Window "toplevel";
   $fyWindow->set_title('Farmyard');
   $fyWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $fyWindow->set_resizable(FALSE);

   # create  farmyard lights

   $fyRed = Tosf::Widgit::Light->new(header => "Red");
   $fyGreen = Tosf::Widgit::Light->new(header => "Green");
   $fyYellow = Tosf::Widgit::Light->new(header => "Amber");

   # create vbox and place  farmyard lights  in vbox

   my $fyVbox = Gtk2::VBox->new( FALSE, 3 );
   $fyVbox->pack_start($fyRed->get_canvas(),FALSE,FALSE,0);
   $fyVbox->pack_start($fyYellow->get_canvas(),FALSE,FALSE,0);
   $fyVbox->pack_start($fyGreen->get_canvas(),FALSE,FALSE,0);
   $fyWindow->add($fyVbox);

   # initialize farmyard lights

   $fyRed->set_light('red');
   $fyYellow->set_light('gray');
   $fyGreen->set_light('gray');


   $hwWindow->show_all;
   $fyWindow->show_all;
   $carWindow->show_all;

}

 sub set_lights {
   my $class = shift @_;
   my @params = @_;

   $hwRed->set_light($params[0]);
   $hwYellow->set_light($params[1]);
   $hwGreen->set_light($params[2]);
   $fyRed->set_light($params[3]);
   $fyYellow->set_light($params[4]);
   $fyGreen->set_light($params[5]);
}

1;
