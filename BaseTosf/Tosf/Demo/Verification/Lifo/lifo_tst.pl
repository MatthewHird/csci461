#!/usr/bin/perl
######################################################
# Peter Walsh
# lifo test driver
######################################################

use lib '../../../../';
use Tosf::Demo::Lifo;

$s0 = Tosf::Demo::Lifo->new(max => 10);
print("Initial stack size ", $s0->size(), "\n");
$s0->push(0);
$s0->push(1);
$s0->push(6);
$s0->push(9);
$s0->push(12);
print ("Top should be 12 Top = ", $s0->top(), "\n");
$s0->pop();
print ("Top should be 9 Top = ", $s0->top(), "\n");
print("stack size ", $s0->size(), "\n");
$s0->dump();
