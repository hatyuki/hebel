use strict;
use warnings;
use t::Util;
use Test::More;
use File::Spec;
use Hebel::Config;

my $config = Hebel::Config->current;
my $file   = File::Spec->catfile(basedir, 'config', 'test.pl');
is_deeply $config, do "$file";

done_testing;
