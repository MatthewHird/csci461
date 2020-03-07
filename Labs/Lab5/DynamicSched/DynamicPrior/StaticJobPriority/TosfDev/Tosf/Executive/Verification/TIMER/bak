#!/usr/bin/perl
######################################################
# Peter Walsh
# TIMER test driver
######################################################

use lib '../../../../';
use Time::HiRes qw (ualarm);
use Tosf::Executive::TIMER;
$SIG{ALRM} = sub {print("tick\n");};

Tosf::Executive::TIMER->set_period(1.0);
Tosf::Executive::TIMER->start();
my $t = Tosf::Executive::TIMER->s2t(3);
print("Conv to Ticks $t \n");
my $s = Tosf::Executive::TIMER->t2s($t);
print("Conv back to Sec $t \n");

while (1) {
}
