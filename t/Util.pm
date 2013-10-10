package t::Util;
use strict;
use warnings;
use parent qw/ Exporter /;
use File::Spec;
use File::Basename qw/ dirname /;
my $basedir;
BEGIN {
    unless ($ENV{PLACK_ENV}) {
        $ENV{PLACK_ENV} = 'test';
    }
    if ($ENV{PLACK_ENV} eq 'deployment') {
        die "Do not run a test script on deployment environment";
    }

    $basedir = File::Spec->catdir(dirname(dirname(__FILE__)));
}
use lib File::Spec->catdir($basedir, 'lib');
use Test::More 0.98;

our @EXPORT = qw/ basedir /;

{
    # utf8 hack.
    binmode Test::More->builder->$_, ":utf8" for qw/ output failure_output todo_output /;
    no warnings 'redefine';
    my $code = \&Test::Builder::child;
    *Test::Builder::child = sub {
        my $builder = $code->(@_);
        binmode $builder->output,         ":utf8";
        binmode $builder->failure_output, ":utf8";
        binmode $builder->todo_output,    ":utf8";
        return $builder;
    };
}

sub basedir { return $basedir }

package Time::Machine;
use Time::Piece ( );
no strict 'refs';
no warnings 'redefine';

sub new
{
    my ($class, $datetime) = @_;
    my $origin = \&Time::Piece::localtime;
    $datetime ||= Time::Piece->new(0);

    *Time::Piece::localtime = sub { $datetime };

    return bless [ $origin ], $class;
}

sub DESTROY
{
    my $self   = shift;
    *Time::Piece::localtime = $self->[0];
}

1;
