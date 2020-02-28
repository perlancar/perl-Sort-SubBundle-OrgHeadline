package Sort::Sub::by_ascii_then_num;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010;
use strict;
use warnings;

sub meta {
    return {
        v => 1,
        summary => 'Sort non-numbers (sorted asciibetically) before numbers (sorted numerically)',
    };
}

sub gen_sorter {
    my ($is_reverse, $is_ci) = @_;

    my $re_is_num = qr/\A
                       [+-]?
                       (?:\d+|\d*(?:\.\d*)?)
                       (?:[Ee][+-]?\d+)?
                       \z/x;

    sub {
        no strict 'refs';

        my $caller = caller();
        my $a = @_ ? $_[0] : ${"$caller\::a"};
        my $b = @_ ? $_[1] : ${"$caller\::b"};

        my $cmp = 0;
        if ($a =~ $re_is_num) {
            if ($b =~ $re_is_num) {
                $cmp = $a <=> $b;
            } else {
                $cmp = 1;
            }
        } else {
            if ($b =~ $re_is_num) {
                $cmp = -1;
            } else {
                $cmp = $is_ci ?
                    lc($a) cmp lc($b) : $a cmp $b;
            }
        }
        $is_reverse ? -1*$cmp : $cmp;
    };
}

1;
# ABSTRACT:

=for Pod::Coverage ^(gen_sorter|meta)$
