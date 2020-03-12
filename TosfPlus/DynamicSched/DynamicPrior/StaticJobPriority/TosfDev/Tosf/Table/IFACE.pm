package Tosf::Table::IFACE;
#================================================================--
# File Name    : Table/IFACE.pm
#
# Purpose      : table of Iface records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
use constant TRUE => 1;
use constant FALSE => 0;

my %table;

# interface is primary key

sub get_keys {

   return keys(%table);
}

sub add {
   my $pkg = shift @_;
   my %params = @_;

   if (!defined($params{interface})) {
      die(Tosf::Exception::Trap->new(interface => "Tosf::Table::IFACE->add interface undefined"));
   }

   my $interface = $params{interface};

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   if (defined($params{handler})) {
      $table{$interface}->set_handler($params{handler});
   } else {
      die(Tosf::Exception::Trap->new(interface => "Tosf::Table::IFACE->add handler undefined"));
   }
}


sub set_heartbeatCount {
   my $pkg = shift @_;
   my $interface = shift @_;
   my $i = shift @_;

   if (!defined($interface) || (!defined($i))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->set_heartbeatCount"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_heartbeatCount($i);
}

sub set_handler {
   my $pkg = shift @_;
   my $interface = shift @_;
   my $h = shift @_;

   if (!defined($interface) || (!defined($h))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->set_handler"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_handler($h);
}

sub set_inRightFrame {
   my $self = shift @_;
   my $interface = shift @_;
   my $f = shift @_;

   if (!defined($interface) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->set_inRightFrame"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_inRightFrame($f);

   return;
}

sub set_outRightFrame {
   my $self = shift @_;
   my $interface = shift @_;
   my $f = shift @_;

   if (!defined($interface) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(interface => "Tosf::Table::IFACE->set_outRightFrame"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_outRightFrame($f);

   return;
}

sub set_outLeftFrame {
   my $self = shift @_;
   my $interface = shift @_;
   my $f = shift @_;

   if (!defined($interface) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(interface => "Tosf::Table::IFACE->set_outLeftFrame"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_outLeftFrame($f);

   return;
}

sub set_inLeftFrame {
   my $self = shift @_;
   my $interface = shift @_;
   my $f = shift @_;

   if (!defined($interface) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->set_inLeftFrame"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_inLeftFrame($f);

   return;
}

sub set_duplicateFlag {
   my $pkg = shift @_;
   my $interface = shift @_;
   my $f = shift @_;

   if (!defined($interface) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->set_duplicateFlag  invalid parameters"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_duplicateFlag($f);
}

sub get_duplicateFlag {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->get_duplicateFlag missing parameter"));
   }

   if (exists($table{$interface})) {
      return $table{$interface}->get_duplicateFlag();
   } else {
      return undef;
   }
}

sub set_dropFlag {
   my $pkg = shift @_;
   my $interface = shift @_;
   my $f = shift @_;

   if (!defined($interface) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->set_dropFlag  invalid parameters"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_dropFlag($f);
}

sub get_dropFlag {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->get_dropFlag missing parameter"));
   }

   if (exists($table{$interface})) {
      return $table{$interface}->get_dropFlag();
   } else {
      return undef;
   }
}

sub get_heartbeatCount {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->get_heartbeatCount"));
   }

   if (exists($table{$interface})) {
      return $table{$interface}->get_heartbeatCount();
   } else {
      return undef;
   }
}

sub increment_heartbeatCount {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->increment_heartbeatCount"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->increment_heartbeatCount();
}


sub get_handler {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->get_handler"));
   }

   if (exists($table{$interface})) {
      return $table{$interface}->get_handler();
   } else {
      return undef;
   }
}

sub set_opened {
   my $pkg = shift @_;
   my $interface = shift @_;
   my $o = shift @_;

   if (!defined($interface) || (!defined($o))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->set_opened"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   }

   $table{$interface}->set_opened($o);
}

sub get_opened {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->get_opened interface undefined"));
   }

   if (exists($table{$interface})) {
      return $table{$interface}->get_opened();
   } else {
      return undef;
   }
}

sub flush {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->flush"));
   }

   if (exists($table{$interface})) {
      $table{$interface}->flush();
   } 
}

sub dequeue_packet_fragment {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->dequeue_packet_fragment"));
   }

   if (exists($table{$interface})) {
      return $table{$interface}->dequeue_packet_fragment();
   } else {
      return undef;
   } 
}

sub dequeue_packet {
   my $pkg = shift @_;
   my $interface = shift @_;

   if (!defined($interface)) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->dequeue_packet"));
   }

   if (exists($table{$interface})) {
      return $table{$interface}->dequeue_packet();
   } else {
      return undef;
   } 
}

sub enqueue_packet {
   my $pkg = shift @_;
   my $interface = shift @_;
   my $p = shift @_;

   if (!defined($interface) || (!defined($p))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->enqueue_packet"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   } 

   $table{$interface}->enqueue_packet($p);
}

sub enqueue_packet_fragment {
   my $pkg = shift @_;
   my $interface = shift @_;
   my $f = shift @_;

   if (!defined($interface) || (!defined($f))) {
      die(Tosf::Exception::Trap->new(name => "Tosf::Table::IFACE->enqueue_packet_fragment"));
   }

   if (!exists($table{$interface})) {
      $table{$interface} = Tosf::Record::Iface->new();
   } 

   $table{$interface}->enqueue_packet_fragment($f);
}


sub dumps {
   my $self = shift @_;

   my $key;
   my $s = '';

   foreach $key (keys(%table)) {
      $s = $s . "Iface: $key ";
      $s = $s . $table{$key}->dumps();
      $s = $s . "\n";
   } 

   return $s;
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
