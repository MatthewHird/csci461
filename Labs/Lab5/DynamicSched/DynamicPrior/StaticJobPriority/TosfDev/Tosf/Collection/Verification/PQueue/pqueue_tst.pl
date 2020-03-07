#!/usr/bin/perl
######################################################
# Peter Walsh
# File: pqueue_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Collection::PQueue;
use Tosf::Exception::Trap;

my $x = Tosf::Collection::PQueue->new();
my $y = Tosf::Collection::PQueue->new();
print ($x->get_siz(), "\n");

print ($y->get_siz(), "\n");

$x->enqueue("Hello", 0);
$x->enqueue("world", 1);

$y->enqueue("foo", 0);
$y->enqueue("bar" ,1);
$y->enqueue("Demo3, 0");

print ($x->get_siz(), "\n");
print ($y->get_siz(), "\n");

print ($x->dequeue(), "\n");
print ($y->dequeue(), "\n");

print ($x->get_siz(), "\n");
print ($y->get_siz(), "\n");

print ($x->dequeue(), "\n");
print ($y->dequeue(), "\n");

$y->dump();
print ("Last el ", $y->dequeue(), "\n");
$y->dump();
