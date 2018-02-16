use v6.c;
use Test;
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
is $p.tokens, ['foo', 0, 'bar'], 'tokens method works for simple pointer';
is $p.resolve($sample-json), 42, 'resolve works for simple pointer';

# ~ and / are escaped as ~0 and ~1
my $p2 = JSON::Pointer.parse('/foo/1/weird~0odd~1name');
is $p2.tokens, ['foo', 1, 'weird~odd/name'], 'tokens method works for escaped pointer';
is $p2.resolve($sample-json), 101, 'resolve works for escaped pointer';

# A Failure is returned upon resolution failure
my $p3 = JSON::Pointer.parse('/foo/2/missing');
with $p3.resolve($sample-json) {
    flunk "Non-existent pointer was resolved";
} else {
    pass "Could not resolve non-existent pointer";
}

# Construct a JSON pointer
my $p4 = JSON::Pointer.new('foo', 0, 'weird~odd/name');
is ~$p4, '/foo/0/weird~0odd~1name', 'Pointer correctly applies Str';

# SUbstitution order
my $p5 = JSON::Pointer.new('~01');
is ~$p5, '/~01', 'Pointer correctly applies Str';

done-testing;
