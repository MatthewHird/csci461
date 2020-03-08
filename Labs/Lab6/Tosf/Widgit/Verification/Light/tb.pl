#================================================================--
# File Name    : tb.cew
#
# Purpose      : unit testing (template)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 1.0          PW      Oct 12  New version
#================================================================--

$| = 1;
use strict;
use warnings;

use lib '../../../../';
use Tosf::Exception::Trap;
use Try::Tiny;

my $cew_Test_Count  = 0;
my $cew_Error_Count = 0;
no warnings "experimental::smartmatch";

print("\n**********Summary**********\n");
print( "Total number of test cases = ",          $cew_Test_Count,  "\n" );
print( "Total number of test cases in error = ", $cew_Error_Count, "\n" );

