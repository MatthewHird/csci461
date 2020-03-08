#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/Iface/iface_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Record::Iface;
use Tosf::Collection::Line;
use Tosf::Exception::Trap;

my $x = Tosf::Record::Iface->new();

$x->set_opened('1');
$x->enqueue_packet("Peter");
$x->set_inRightFrame("FRAME_IN_RIGHT");
$x->set_outRightFrame("FRAME_OUT_RIGHT");
$x->set_outLeftFrame("FRAME_OUT_LEFT");
$x->set_inLeftFrame("FRAME_IN_LEFT");
$x->dump();

my $y = Tosf::Record::Iface->new();
$y->set_opened('0');
$y->set_heartbeatFlag(22);
$y->enqueue_packet("paul");
$y->set_dropFlag(1);
$y->set_duplicateFlag(2);
$y->dump();
