unit module AOC13;

grammar List is export {
    token TOP { <term> }
    rule term { <integer> | <termlist> }
    token integer { \d+ }
    rule termlist { '[' <term>* % ',' ']' }
}

class ListBuilder is export {
    method TOP ($/) { make $<term>.made }
    method term ($/) { make $<integer> ?? $<integer>.made !! $<termlist>.made }
    method integer ($/) { make $/.Int }
    method termlist ($/) { make $<term>.Array».made }
}

sub lcmp ($l, $r) is export {
    if $l ~~ Int && $r ~~ Int {
        return $l <=> $r;
    } elsif $l ~~ Array && $r ~~ Array {
        for @$l Z @$r -> ($ll, $rr) {
            my $cmp = lcmp($ll, $rr);
            return $cmp if $cmp;
        }
        return $l.elems <=> $r.elems;
    } elsif ($l ~~ Array && $r ~~ Int) {
        return lcmp($l, [$r]);
    } elsif ($l ~~ Int && $r ~~ Array) {
        return lcmp([$l], $r);
    } else {
        die "Can't compare {$l.raku} to {$r.raku}";
    }
}

