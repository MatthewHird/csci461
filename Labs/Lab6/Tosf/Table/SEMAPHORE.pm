package Tosf::Table::SEMAPHORE;
#================================================================--
# File Name    : SEMAPHORE.pm
#
# Purpose      : table of Semaphore records
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
         $table{$params{name}} = Tosf::Record::Semaphore->new();
      } else {
         die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->add name duplicate"));
      }
   } else {
      dYie(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->add name undefined"));
   }

   if (defined($params{max})) {
      $table{$params{name}}->set_max($params{max});
   }

   if (defined($params{value})) {
      if ($params{value} > $table{$params{name}}->get_max()) {
         die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->add value > max"));
      } else {
         $table{$params{name}}->set_value($params{value});
      }
   }

}

sub get_value {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->get_value name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->get_value name = $name not in table"));
   }

   return ($table{$name}->get_value());
}

sub get_max {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->get_max name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->get_max name = $name not in table"));
   }

   return ($table{$name}->get_max());
}

sub set_value {
   my $pkg = shift @_;
   my $name = shift @_;
   my $v = shift @_;

   if (!defined($name)) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->set_value name undefined"));
   }

   if (!exists($table{$name})) {
      die(Tosf::::Exception::Trap->new(name => "Table::SEMAPHORE->set_value name = $name not in table"));
   }

   $table{$name}->set_value($v);
}

sub wait {
   my $pkg = shift @_;
   my %params = @_;

   if (!defined($params{semaphore})) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->wait semaphore name undefined"));
   }

   if (!exists($table{$params{semaphore}})) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->wait name = $params{semaphore} name not in table"));
   }

   if (!defined($params{task})) {
      $table{$params{semaphore}}->wait(Tosf::Collection::STATUS->get_currentExecutingTask());
   } else {
      $table{$params{semaphore}}->wait($params{task});
   }
      

}

sub signal {
   my $pkg = shift @_;
   my %params = @_;

   if (!defined($params{semaphore})) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->signal semaphore undefined"));
   }

   if (!exists($table{$params{semaphore}})) {
      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->signal $params{semaphore} not in table"));
   }

   #print("Signal ", $params{semaphore}, "\n");
   $table{$params{semaphore}}->signal();
}

#sub resume {
#   my $pkg = shift @_;
#   my %params = @_;
#
#   if (!defined($params{semaphore})) {
#      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->resume $params{semaphore} undefined"));
#   }
#
#   if (!defined($params{task})) {
#      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->resume $params{task} undefined"));
#   }
#
#   if (!exists($table{$params{semaphore}})) {
#      die(Tosf::Exception::Trap->new(name => "Table::SEMAPHORE->resume $params{semaphore}  not in table"));
#   }
#
#   $table{$params{semaphore}}->resume($params{task});
#}

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
