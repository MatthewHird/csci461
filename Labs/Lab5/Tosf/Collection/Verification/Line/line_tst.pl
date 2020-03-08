#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Collection/Verification/Line/line_tst.pl
# Module test driver
# Marius' test case
######################################################

use lib '../../../../';
use Tosf::Collection::Line;

use constant PCHAR_ESC => '_G_';
use constant PCHAR_END => '_H_';

$x = Tosf::Collection::Line->new(
   maxbuff => 1000 
);
$x->dump();

print("------------------------------\n");

$x->enqueue_packet_fragment('_garbage_');
$x->enqueue_packet_fragment(PCHAR_ESC . 'pet');
$x->enqueue_packet_fragment('er' . PCHAR_END);
$x->enqueue_packet_fragment(PCHAR_ESC . 'yy' ); # missing PCHAR_END
$x->enqueue_packet_fragment(PCHAR_ESC . 'zz' . PCHAR_END);
$x->enqueue_packet_fragment(PCHAR_ESC . 'ww' . PCHAR_END);
$x->enqueue_packet_fragment(PCHAR_ESC . 'Ping' . PCHAR_END);

# Expected output
# Packet 1 Peter
# Packet 2 yyzz
# Packet 3 ww
# Packet 3 Ping
# No Packet returned


$pk = $x->dequeue_packet();
print ("PACKET ", $pk , "\n");
$pk = $x->dequeue_packet();
print ("PACKET ", $pk , "\n");
$pk = $x->dequeue_packet();
print ("PACKET ", $pk , "\n");
$pk = $x->dequeue_packet();
if (defined($pk)) {
   print ("PACKET ", $pk , "\n");
} else {
   print ("No packet returned\n");

}

$x->dump();


print("------------------------------\n");
$x = Tosf::Collection::Line->new(
   maxbuff => 1000 ,
   inLeftFrame => 'sc',
   inRightFrame => "\r",
   outLeftFrame => ' ',
   outRightFrame => "\r"
);

$x->enqueue_packet_fragment('sc' . 'peter' . "\r");
$pk = $x->dequeue_packet();
print ("PACKET ", $pk , "\n");
$x->enqueue_packet('paul');
$x->dump();

print("------------------------------\n");
$x = Tosf::Collection::Line->new(
   maxbuff => 1000 ,
   inLeftFrame => '_X_',
   inRightFrame => "_Y_",
   outLeftFrame => '_X_',
   outRightFrame => "\r"
);

$x->enqueue_packet("peter");
$pk = $x->dequeue_packet_fragment();
print ("PACKET FRAG", $pk , "\n");
$x->dump();



