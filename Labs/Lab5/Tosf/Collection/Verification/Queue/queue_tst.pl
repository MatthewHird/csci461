#!/usr/bin/perl
######################################################
# Peter Walsh
# File: queue_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Collection::Queue;

my $x = Tosf::Collection::Queue->new();
my $y = Tosf::Collection::Queue->new();
print ($x->get_siz(), "\n");
$a = $y->is_member("foo");
print("Is member foo $a \n"); 

print ($x->get_siz(), "\n");

$x->enqueue("Hello");
$x->enqueue("world");
$x->dump();
my $p = $x->dumps();
print("Dumps: \n$p \n");

$y->enqueue("foo");
$y->enqueue("bar");
$y->enqueue("Demo3");

$a = $y->is_member("foo");
print("Is member foo $a \n"); 
$a = $y->is_member("bar");
print("Is member bar $a \n"); 
$a = $y->is_member("Demo3");
print("Is member Demo3 $a \n"); 
$a = $y->is_member("Demo4");
print("Is member Demo4 $a \n"); 

print ($x->get_siz(), "\n");
print ($y->get_siz(), "\n");

print ($x->dequeue(), "\n");
print ($y->dequeue(), "\n");
$a = $y->is_member("foo");
print("Is member foo $a \n"); 
# delete test
$y->dump();
print("===============\n");
$y->enqueue("dtest");
$y->enqueue("Demo4");
$y->dump();
print("===============\n");
$a = $y->is_member("dtest");
print("Is member dtest $a \n"); 
$y->delete("dtest");
print("==Delete=========\n");
$y->dump();
$a = $y->is_member("dtest");
print("Is member dtest $a \n"); 
