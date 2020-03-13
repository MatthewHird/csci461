changecom(`#')

define(mmt_TableBegin,
   `sub set_name {
      my $self = shift @_;
      my $nme = shift @_;

      return $nme;
    }

    sub tick {  
      my $self = shift @_;
      my $mmt_currentState = shift @_; 
      no warnings "experimental::smartmatch"; '

)

define(mmt_TableRow,
   `if ($mmt_currentState ~~ $1) {
      $2;
      return ($3);
   } '
)

define(mmt_TableEnd,
  `};'
)

define(mmt_Reset,
  `sub reset {
      my $self = shift @_;

      $2;
      return ($1); 
   }; '
)
