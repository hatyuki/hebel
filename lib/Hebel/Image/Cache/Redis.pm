package Hebel::Image::Cache::Redis;
use strict;
use warnings;
use parent qw/ Hebel::Image::Cache /;
use Redis;
use Time::Piece ( );
use Class::Accessor::Lite (
    new => 0,
    ro  => [qw/ prefixkey redis /],
    rw  => [qw/ ttl /],
);

sub new
{
    my $class  = shift;
    my %args   = scalar @_ == 1 && ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $config = delete $args{redis} || +{ };
    $config->{encoding} = undef;

    return bless {
        prefixkey => $args{prefixkey} || __PACKAGE__,
        redis     => Redis->new(%$config),
        ttl       => $args{ttl} || 600,
    }, $class;
}

sub set
{
    my ($self, $key, $value) = @_;
    my $redis = $self->redis;

    $redis->set($key, $value);
    $redis->expireat($key, $self->expireat);

    return $value;
}

sub get
{
    my ($self, $key) = @_;
    my $redis = $self->redis;

    if (my $cache = $redis->get($key)) {
        $redis->expireat($key, $self->expireat);
        return $cache;
    }
}

sub expireat
{
    my $self = shift;
    my $now  = Time::Piece->localtime;
    return $now->epoch + $self->ttl;
}

sub to_key
{
    my ($self, $origin) = @_;
    return sprintf "%s::%s", $self->prefixkey, $origin;
}

1;
