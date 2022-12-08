my @m = $*ARGFILES.IO.lines».comb».Int;

my @rc = @m.keys X @m[0].keys;
my (@vt, @vb, @vl, @vr);

for @rc -> ($r, $c) {
    @vt[$r][$c] = $r > 0 ?? max(@vt[$r-1][$c], @m[$r-1][$c]) !! -1;
    @vl[$r][$c] = $c > 0 ?? max(@vl[$r][$c-1], @m[$r][$c-1]) !! -1;
}

for @rc.reverse -> ($r, $c) {
    @vb[$r][$c] = $r < @m.elems - 1 ?? max(@vb[$r+1][$c], @m[$r+1][$c]) !! -1;
    @vr[$r][$c] = $c < @m[0].elems - 1 ?? max(@vr[$r][$c+1], @m[$r][$c+1]) !! -1;
}

my $vis = 0;
for @rc -> ($r, $c) {
    my $t = @m[$r][$c];
    my $visible = $t > @vt[$r][$c] || $t > @vb[$r][$c] || $t > @vl[$r][$c] || $t > @vr[$r][$c];
    $vis++ if $visible;
    # say "($r, $c): $t V:$visible T:@vt[$r][$c] B:@vb[$r][$c] L:@vl[$r][$c] R:@vr[$r][$c]";
}

say $vis;
