package Hebel::Image::Cache::Null;
use strict;
use warnings;
use parent qw/ Hebel::Image::Cache /;

sub new { return bless [ ], $_[0] }
sub set { }
sub get { }

1;
