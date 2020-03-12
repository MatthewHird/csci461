#!/usr/bin/perl

# Calculation for the number of problem
# combinations (almalagations) A

# Peter Walsh csci 461 2020

my $m;
my $s;
my $i;
my $total = 0;

# from Perl Monks
sub combination {
   my( $n, $r ) = @_;
   return unless defined $n && $n =~ /^\d+$/ && defined $r && $r =~ /^\d+$/;
   my $product = 1;
   while( $r > 0 ) {
      $product *= $n--;
      $product /= $r--;
   }
   return $product;
}

print("Enter m (the number of frames) ");
$m = <>;
print("Enter s (the number of potiential job splits) ");
$s = <>;
chop($m);

for ($i=1; $i<=$s; $i++) {

   $total = $total + combination($m, $i);

}

print("The value if A is $total \n");
