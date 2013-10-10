package Hebel::Web;
use strict;
use warnings;
use parent qw/ Hebel Amon2::Web /;

# dispatcher
use Hebel::Web::Dispatcher;
sub dispatch
{
    return (Hebel::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

1;
