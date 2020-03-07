package Tosf::Table::SVAR;
#================================================================--
# File Name    : SVAR.pm
#
# Purpose      : table of SVar records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my %table;

sub get_keys {

   return keys(%table);
}

sub add {
   my $pkg = shift @_;
   my %params = @_;

   if (defined($params{name})) {
      if (!exists($table{$params{name}})) {
         $table{$params{name}} = Tosf::Record::SVar->new();
      } else {
         die(Tosf::Exception::Trap->new(name => "Table::SVAR->add name duplicate"));
      }
   } else {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->add name undefined"));
   }

   if (defined($params{value})) {
      $table{$params{name}}->set_value($params{value});
      $table{$params{name}}->set_nextValue($params{value});
   } else {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->add value undefined"));
   }

   if (defined($params{nextValue})) {
      $table{$params{name}}->set_nextValue($params{nextValue});
   } 
}

sub get_value {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->get_value name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->get_value name = $name not in table"));
   }

   return ($table{$name}->get_value());
}

sub set_value {
   my $pkg = shift @_;
   my $name = shift @_;
   my $v = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->set_value name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->set_value name = $name not in table"));
   }

   $table{$name}->set_value($v);
}

sub change {
   my $pkg = shift @_;
   my $name = shift @_;
   my $v = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->change name undefined"));
   }

   $table{$name}->set_value($v);
   $table{$name}->set_nextValue($v);
}

sub assign {
   my $pkg = shift @_;
   my $name = shift @_;
   my $v = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->set_value name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->set_value name = $name not in table"));
   }

   $table{$name}->assign($v);
}

sub get_nextValue {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->get_nextValue name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->get_nextValue name = $name not in table"));
   }

   return ($table{$name}->get_nextValue());
}

sub set_nextValue {
   my $pkg = shift @_;
   my $name = shift @_;
   my $v = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->set_nextValue name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->set_nextValue name = $name not in table"));
   }

   $table{$name}->set_nextValue($v);
}

sub update_all {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      $table{$key}->update();    
   } 
}

sub update {
   my $self = shift @_;
   my $sv = shift @_;

   if (!defined($sv)) {
      die(Tosf::Exception::Trap->new(name => "Table::SVAR->update sv undefined"));
   }

   $table{$sv}->update();    
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Name: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}

1;
