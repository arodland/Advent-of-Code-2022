my ($x, $cycle, $str) = (1, 0, 0);

sub cycle {
    $cycle = $cycle % 40 + 1;
    if $x - $cycle ~~ -2 .. 0 {
        print "#";
    } else {
        print ".";
    }
    if $cycle %% 40 {
        print "\n";
    }
}
for $*ARGFILES.IO.lines -> $line {
    my @words = $line.words;
    if @words[0] eq 'addx' {
        cycle();
        cycle();
        $x += @words[1].Int;
    } elsif @words[0] eq 'noop' {
        cycle();
    } else {
        die "huh? $line";
    }
}
