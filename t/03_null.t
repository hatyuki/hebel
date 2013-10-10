use strict;
use warnings;
use t::Util;
use Test::More;
use Hebel::Image::Cache::Null;

subtest basic => sub {
    my $cache = Hebel::Image::Cache::Null->new;
    isa_ok $cache, 'Hebel::Image::Cache::Null';
    is $cache->set(key => 'value'), undef;
    is $cache->get('key'), undef;
};

done_testing;
