#!/usr/bin/perl
######################################################
# Peter Walsh
# Monitor test driver
######################################################

use lib '../../../../';
use Tosf::Exception::Monitor;
use Tosf::Exception::Trap;

$s0 = Tosf::Exception::Monitor->new(
   fn => sub { 

      print("Hello World Peter \n"); 
      
      die(Tosf::Exception::Trap->new(name => "full", description => "this is the full exception description"));
   } 
);

$s0->run();

