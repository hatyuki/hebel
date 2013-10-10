use strict;
use warnings;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Plack::Builder;
use Hebel::Web;


builder {
    enable 'ReverseProxy';
    enable 'Log::Minimal';

    Hebel::Web->to_app;
};
