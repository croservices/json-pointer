use v6.c;
unit class JSON::Pointer:ver<0.0.1>;

class X::JSON::Pointer::InvalidSyntax is Exception {
    has $.pos;
    has $.pointer;

    method message() {
        "Invalid syntax at {$!pos} when trying to resolve {$!pointer}"
    }
}

class X::JSON::Pointer::NonExistent is Exception {
    has $.element;

    method message() {
        "Element does not exist at $!element"
    }
}

=begin pod

=head1 NAME

JSON::Pointer - JSON Pointer implementation in Perl 6.

=head1 SYNOPSIS

  use JSON::Pointer;

  # An example document to resolve pointers in
  my $sample-json = {
      foo => [
          {
              bar => 42
          },
          {
              'weird~odd/name' => 101
          }
      ]
  }

  # Simple usage
  my $p = JSON::Pointer.parse('/foo/0/bar');
  say $p.tokens; # [foo 0 bar]
  say $p.resolve($sample-json); # 42

  # ~ and / are escaped as ~0 and ~1
  my $p2 = JSON::Pointer.parse('/foo/1/weird~0odd~1name');
  say $p2.tokens; # [foo 1 weird~odd/name]
  say $p2.resolve($sample-json); # 101

  # A Failure is returned upon resolution failure
  my $p3 = JSON::Pointer.parse('/foo/2/missing');
  without $p3.resolve($sample-json) {
      say "Could not resolve";
  }

  # Construct a JSON pointer
  my $p4 = JSON::Poiner.new('foo', 0, 'weird~odd/name');
  say ~$p4; # /foo/0/weird~0odd~1name

=head1 DESCRIPTION

JSON::Pointer is a Perl 6 module that implements JSON Pointer conception.

=head1 AUTHOR

Alexander Kiryuhin <alexander.kiryuhin@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Edument Central Europe sro.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
