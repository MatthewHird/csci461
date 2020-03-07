package goldApp::Plant::MENU;
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
use constant MAXSEL => 3;

sub start {

   my $inp;
   my $sel = -1;

   #system('clear');

   while (($sel < 0) || ($sel > MAXSEL))  {

      print ("\nBoot Menu\n\n");
      print("\tGoldberg GUI Client 0\n");
      print("\tGoldberg Headless Batch Test Client 1\n");
      print("\tGoldberg Hub 2\n");
      print("\tGoldber Server 3\n");
      print ("\nEnter selection (CTRL C to exit) ");
      $inp = <>;
      chop($inp);
      if (($inp =~ m/\d/) && (length($inp) == 1)) {
         $sel = int($inp);
      }

   }

   #system('clear');

   if ($sel == 0) {
      goldApp::Plant::LIGHTS->start();
      goldApp::Plant::GCLIENTSETUP->start();
   } elsif ($sel == 1) {
      goldApp::Plant::TCLIENTSETUP->start();
   } elsif ($sel == 2) {
      print("Sel 2 \n");
      exit();
   } elsif ($sel == 3) {
      print("Sel 3 \n");
      exit();
   }
}

1;
