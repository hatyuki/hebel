package Hebel::Config;
use strict;
use warnings;
use Amon2::Util;
use Carp ( );
use Config::ENV qw/ PLACK_ENV /, default => 'development';
use File::Spec;

my $basedir  = Amon2::Util::base_dir(__PACKAGE__);
my $env      = Config::ENV::env( );
my $filepath = File::Spec->catfile($basedir, 'config', "$env.pl");
Carp::croak "Could not load configuration file: '$filepath'" unless -f $filepath;
config $env => +{ load($filepath) };

1;
