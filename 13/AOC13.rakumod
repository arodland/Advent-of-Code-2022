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

proto sub lcmp (|) is export {*};
multi sub lcmp ($l, $r) { $l <=> $r }
multi sub lcmp (@l, @r) {
    for @l Z @r -> ($ll, $rr) {
        my $cmp = lcmp($ll, $rr);
        return $cmp if $cmp;
    }
    return @l.elems <=> @r.elems;
}
multi sub lcmp (@l, $r) { lcmp(@l, [$r]) }
multi sub lcmp ($l, @r) { lcmp([$l], @r) }
