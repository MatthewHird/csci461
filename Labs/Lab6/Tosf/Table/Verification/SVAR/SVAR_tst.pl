#!/usr/bin/perl
######################################################
# Peter Walsh
# File: SVAR_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Try::Tiny;
use Tosf::Exception::Monitor;
use Tosf::Exception::Trap;
use Tosf::Table::SVAR;
use Tosf::Record::SVar;

my $tst = Tosf::Exception::Monitor->new(
   fn => sub {
      Tosf::Table::SVAR->add(name => "var1", 
         value => 1, 
         nextValue => 0 
      );

      Tosf::Table::SVAR->add(name => "var2", 
         value => 8, 
         nextValue => 7 
      );
      
      Tosf::Table::SVAR->dump();


      Tosf::Table::SVAR->update_all();

      Tosf::Table::SVAR->dump();

   }
);

$tst->run();
