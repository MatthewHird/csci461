#!/usr/bin/perl
######################################################
# Peter Walsh
# TIMER test driver
######################################################

use lib '../../../../';
use Time::HiRes qw (ualarm);
use Tosf::Executive::TIMER;
our $cnt=0;
$SIG{ALRM} = sub {
   #print("tick\n");
   $cnt = $cnt + 1;
};

Tosf::Executive::TIMER->set_period(0.001);
Tosf::Executive::TIMER->start();

while (1) {
   if ($cnt == 15000) {
      print("STOP\n");
      exit;
   }
}
