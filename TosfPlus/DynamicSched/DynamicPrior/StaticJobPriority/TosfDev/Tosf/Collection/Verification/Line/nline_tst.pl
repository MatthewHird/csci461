#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Collection/Verification/Line/nline_tst.pl
# Module test driver
# Marius' test case
######################################################

# added to test where we have '' as a framing character
#
use lib '../../../../';
use Tosf::Collection::Line;

our $x = Tosf::Collection::Line->new(
   maxbuff => 10000,
   inLeftFrame => '',
   inRightFrame => "\n",
   outLeftFrame => '',
   outRightFrame => "\n"
);

print("------------------------------\n");

my $y = "INIT";
$x->enqueue_packet_fragment("Peter \n");
$x->dump();
$y = $x->dequeue_packet();
print("PACKET $y \n");
$x->dump();
print("====================\n");
