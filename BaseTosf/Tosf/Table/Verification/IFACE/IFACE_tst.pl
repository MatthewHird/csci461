#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/IFACE/IFACE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Table::IFACE;
use Tosf::Record::Iface;
use Tosf::Collection::Line;


Tosf::Table::IFACE->set_opened('p0', '1');
Tosf::Table::IFACE->enqueue_packet('p0', 'Test P0');

Tosf::Table::IFACE->set_opened('p1', '0');
Tosf::Table::IFACE->set_handler('p1', "HANDLER");
Tosf::Table::IFACE->enqueue_packet('p1', 'Test P1');
Tosf::Table::IFACE->dump();

#Tosf::Table::IFACE->flush('peter');
Tosf::Table::IFACE->dump();

Tosf::Table::IFACE->enqueue_packet('Interface9', 'HelloWorld\n');
Tosf::Table::IFACE->dump();

print("HHHHHHHHHHHHHHHHHHHHHHH\n");
Tosf::Table::IFACE->set_dropFlag("Peter", 22);
my $v = Tosf::Table::IFACE->get_dropFlag("Peter");
print("Value of drop $v \n");
Tosf::Table::IFACE->set_duplicateFlag("Peter", 33);
$v = Tosf::Table::IFACE->get_duplicateFlag("Peter");
print("Value of duplicate $v \n");
Tosf::Table::IFACE->dump();
