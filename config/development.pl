use strict;
use warnings;
use File::Basename qw/ dirname /;
use File::Spec;
my $basedir = File::Spec->catdir(dirname(dirname(__FILE__)));

return +{
    fontdir => File::Spec->catdir($basedir, 'fonts'),
    font    => 'Perisphere',
    cache   => +{
        ttl   => 5,
        redis => +{
            sock => File::Spec->catfile($basedir, 'var', 'run', 'redis.socket'),
        },
    },
};
