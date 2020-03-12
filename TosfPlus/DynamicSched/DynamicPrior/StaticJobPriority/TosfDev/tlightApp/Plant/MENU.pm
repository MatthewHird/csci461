package tlightApp::Plant::MENU;
#================================================================--
# File Name    : MENU.pm
#
# Purpose      : Plant set-up 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE => 1;
use constant FALSE => 0;
use constant MAXSEL => 0;

sub start {

   my $inp;
   my $sel = -1;

   system('clear');

   while (($sel < 0) || ($sel > MAXSEL))  {

      print ("\nBoot Menu\n\n");
      print("\tCentralized Traffic Light Controller  0\n");
      print ("\nEnter selection (CTRL C to exit) ");
      $inp = <>;
      chop($inp);
      if (($inp =~ m/\d/) && (length($inp) == 1)) {
         $sel = int($inp);
      }

   }

   system('clear');

   if ($sel == 0) {
      tlightApp::Plant::CLIGHTS->start();
      tlightApp::Plant::CCONTROL->start();
   }
}

1;
