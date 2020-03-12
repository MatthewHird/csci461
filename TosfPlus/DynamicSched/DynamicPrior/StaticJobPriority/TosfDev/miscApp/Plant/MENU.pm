package miscApp::Plant::MENU;
#================================================================--
# File Name    : MENU.pm
#
# Purpose      : Plant menu  for Goldberg 
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
use constant MAXSEL => 1;

sub start {

   my $inp;
   my $sel = -1;

   system('clear');

   while (($sel < 0) || ($sel > MAXSEL))  {

      print ("\nBoot Menu\n\n");
      print("\tReaction Tester 0 \n");
      print ("\nEnter selection (CTRL C to exit) ");
      $inp = <>;
      chop($inp);
      if (($inp =~ m/\d/) && (length($inp) == 1)) {
         $sel = int($inp);
      }

   }

   system('clear');

   if ($sel == 0) {
      miscApp::Plant::LIGHTS->start();
      miscApp::Plant::RTSETUP->start();
   } elsif ($sel == 1) {
      print("Sel 1 \n");
      exit();
   } elsif ($sel == 2) {
      print("Sel 2 \n");
      exit();
   } elsif ($sel == 3) {
      print("Sel 3 \n");
      exit();
   }
}

1;
