package Hebel::Image;
use strict;
use warnings;
use File::Temp ( );
use Hebel::Image::Cache::Null;
use Image::Imlib2;
use Log::Minimal;
use Class::Accessor::Lite (
    new => 0,
    ro   => [qw/ cache fontdir /],
    rw   => [qw/ font /],
);

sub new
{
    my $class = shift;
    my %args  = scalar @_ == 1 && ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;
    my $cache = Hebel::Image::Cache::Null->new;

    if (my $config = delete $args{cache}) {
        eval {
            require Hebel::Image::Cache::Redis;
            $cache = Hebel::Image::Cache::Redis->new($config);
        };
        if ($@) {
            warnf $@;
            $cache = Hebel::Image::Cache::Null->new;
        }
    }

    debugf 'Cache Class: %s', ref $cache;

    return bless +{
        cache => $cache,
        %args,
    }, $class;
}

sub generate
{
    my ($self, $width, $height) = @_;
    my $dimensions = dimensions($width, $height);

    if (my $cache = $self->cache->get($dimensions)) {
        debugf "CacheHit: $dimensions";
        return $cache;
    }
    else {
        debugf "CacheMiss: $dimensions";
        my $image = $self->draw($width, $height);
        my $data  = $self->save($image);

        $self->cache->set($dimensions, $data);

        return $data;
    }
}

sub draw
{
    my ($self, $width, $height) = @_;
    my $dimensions = dimensions($width, $height);
    my $image = Image::Imlib2->new($width, $height);
    my $font  = $self->font;

    $image->set_color(220, 220, 220, 255);
    $image->fill_rectangle(0, 0, $width, $height);

    $image->add_font_path($self->fontdir);
    $image->set_color(170, 170, 170, 255);

    my ($x, $y);
    for (my $size = 200 ; $size >= 15 ; $size -= 5) {
        $image->load_font("$font/$size");

        my ($w, $h) = $image->get_text_size($dimensions);
        if ($w < $width * 0.8 && $h < $height * 0.8) {
            $x = ($width  - $w) / 2;
            $y = ($height - $h) / 2;
            $image->draw_text($x, $y, $dimensions);
            last;
        }
    }

    return $image;
}

sub save
{
    my ($self, $image) = @_;
    my $io    = File::Temp->new(UNLINK => 1, SUFFIX => '.png');
    $image->save($io->filename);

    return do { local $/ = undef; <$io> };
}

sub dimensions
{
    return "$_[0]x$_[1]";
}

1;
