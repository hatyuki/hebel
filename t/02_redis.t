use strict;
use warnings;
use t::Util;
use Test::More;
use Test::RedisServer;
use Time::Piece ( );
use Hebel::Image::Cache::Redis;

my $redis = Test::RedisServer->new;

subtest basic => sub {
    my $guard = Time::Machine->new;
    my $cache = Hebel::Image::Cache::Redis->new(redis => +{ $redis->connect_info });

    isa_ok $cache, 'Hebel::Image::Cache::Redis';
    isa_ok $cache->redis, 'Redis';
    is $cache->prefixkey, 'Hebel::Image::Cache::Redis';
    is $cache->to_key('hoge'), 'Hebel::Image::Cache::Redis::hoge';
    is $cache->ttl, 600;
    is $cache->expireat, 600;
};

subtest 'custom args' => sub {
    my $guard = Time::Machine->new;
    my $cache = Hebel::Image::Cache::Redis->new(
        prefixkey => 'CustomPrefix',
        redis     => +{ $redis->connect_info },
        ttl       => 1000,
    );

    isa_ok $cache, 'Hebel::Image::Cache::Redis';
    isa_ok $cache->redis, 'Redis';
    is $cache->prefixkey, 'CustomPrefix';
    is $cache->to_key('hoge'), 'CustomPrefix::hoge';
    is $cache->ttl, 1000;
    is $cache->expireat, 1000;
};

subtest 'set / get' => sub {
    my $value = 'bar';
    my $cache = Hebel::Image::Cache::Redis->new(redis => +{ $redis->connect_info });

    is $cache->set(foo => $value), $value;
    is $cache->get('foo'), $value;
};

subtest expired => sub {
    my $value = 'bar';
    my $guard = Time::Machine->new;
    my $cache = Hebel::Image::Cache::Redis->new(redis => +{ $redis->connect_info });

    is $cache->set(foo => $value), $value;
    is $cache->get('foo'), undef;
};

done_testing;
