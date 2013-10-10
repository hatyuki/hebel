use strict;
use warnings;
use t::Util;
use Test::More;
use Hebel::Image;

subtest constructor => sub {
    my $image = Hebel::Image->new;
    isa_ok $image, 'Hebel::Image';
    isa_ok $image->cache, 'Hebel::Image::Cache::Null';
};

done_testing;
