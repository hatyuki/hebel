package Hebel::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;
use Data::Section::Simple qw/ get_data_section /;
use Plack::Response;
use Hebel::Image;

get '/' => sub {
    my $response = Plack::Response->new(
        200, [
            'Content-Type' => 'text/html',
        ], get_data_section('index.html')
    );

    return $response;
};

any '/{width:\d{1,4}}x{height:\d{1,4}}' => sub {
    my ($c, $args) = @_;
    my ($width, $height) = ($args->{width}, $args->{height});

    my $image = Hebel::Image->new($c->config);
    return Plack::Response->new(
        200, [
            'Content-Type' => 'image/png',
        ], $image->generate($width, $height),
    );
};

1;

__DATA__

@@ index.html
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>Hebel</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css" rel="stylesheet">
  </head>
  <body>
    <header>
      <nav class="navbar navbar-default navbar-static-top">
        <div class="navbar-header">
          <div class="container">
            <span class="navbar-brand">Hebel</span>
          </div><!-- .container -->
        </div><!-- navbar-header -->
      </nav>
    </header>

    <div class="container">
      <div class="jumbotron">
        <div class="container">
          <h1>Welcome to Hebel</h1>
          <p>Hebel is open source software to generate quick and simple image placeholder.</p>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="row">
        <div class="col-sm-6 col-xs-12">
          <h2>How does it work?</h2>
          <p>
            Just put your image size after our URL and you'll get a placeholder.<br />
            Like this:
          </p>
          <pre>http://hebel.example.com/100x100</pre>
          <p>You can also use it in your code, like this:</p>
          <pre>&lt;img src="http://hebel.example.com/100x100"&gt;</pre>
          <strong>Have fun!</strong>
        </div>
        <div class="col-sm-6 col-xs-12">
          <p><img class="img-responsive" src="/555x300"></p>
        </div>
      </div>
    </div>

    <footer style="margin-top: 40px; padding: 40px 0; background-color: #fafafa; border-top: 1px solid #ccc">
      <div class="container">
        <p class="text-muted">
          Code licensed under <a href="//opensource.org/licenses/Artistic-2.0">Artistic License 2.0</a>.
        </p>
        <ul class="list-inline">
          <li><a href="https://github.com/hatyuki/hebel.git"><i class="icon-github"></i></a><li>
          <li><a href="https://twitter.com/hatyuki"><i class="icon-twitter"></i></a><li>
          <li><i class="icon-html5"></i><li>
          <li><i class="icon-linux"></i><li>
        </ul>
      </div>
    </footer>

    <script src="//code.jquery.com/jquery-latest.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
  </body>
</html>
