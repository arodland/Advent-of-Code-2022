my @m = $*ARGFILES.IO.lines».comb».Int;

my @rc = @m.keys X @m[0].keys;
my (@vt, @vb, @vl, @vr);

for ^10 -> $l {
    for @rc -> ($r, $c) {
        @vt[$l][$r][$c] = $r == 0 ?? 0 !!
            @m[$r-1][$c] >= $l ?? 1 !!
            @vt[$l][$r-1][$c] + 1;

        @vl[$l][$r][$c] = $c == 0 ?? 0 !!
            @m[$r][$c-1] >= $l ?? 1 !!
            @vl[$l][$r][$c-1] + 1;
    }

    for @rc.reverse -> ($r, $c) {
        @vb[$l][$r][$c] = $r == @m.elems - 1 ?? 0 !!
            @m[$r+1][$c] >= $l ?? 1 !!
            @vb[$l][$r+1][$c] + 1;

        @vr[$l][$r][$c] = $c == @m[0].elems - 1 ?? 0 !!
            @m[$r][$c+1] >= $l ?? 1 !!
            @vr[$l][$r][$c+1] + 1;
    }
}

my $best = 0;
for @rc -> ($r, $c) {
    my $t = @m[$r][$c];
    my $score = @vt[$t][$r][$c] * @vb[$t][$r][$c] * @vl[$t][$r][$c] * @vr[$t][$r][$c];
    # say "($r, $c): $t → T:@vt[$t][$r][$c] L:@vl[$t][$r][$c] B:@vb[$t][$r][$c] R:@vr[$t][$r][$c] score:$score";
    $best = $score if $score > $best;
}

say "best: $best";
