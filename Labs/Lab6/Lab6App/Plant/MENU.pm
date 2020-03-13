package Lab6App::Plant::MENU;
#================================================================--
# File Name    : MENU.pm
#
# Purpose      : Plant menu 
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

   system('clear');

   while (($sel < 0) || ($sel > MAXSEL))  {

      print ("\nBoot Menu\n\n");
      print("\tTrace  0\n");
      print("\tTrace  1\n");
      print("\tTrace  2\n");
      print("\tTrace  3\n");
      print ("\nEnter selection (CTRL C to exit) ");
      $inp = <>;
      chop($inp);
      if (($inp =~ m/\d/) && (length($inp) == 1)) {
         $sel = int($inp);
      }

   }

   if ($sel == 0) {
      Lab6App::Plant::TRACE0->start();
   } elsif ($sel == 1) {
      Lab6App::Plant::TRACE1->start();
   } elsif ($sel == 2) {
      Lab6App::Plant::TRACE2->start();
   } elsif ($sel == 3) {
      Lab6App::Plant::TRACE3->start();
   }
   
}

1;
