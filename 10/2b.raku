my ($x, $cycle) = (1, 0);

sub cycle {
    $cycle = $cycle % 40 + 1;
    print $x - $cycle ~~ -2 .. 0 ?? "#" !! ".";
    print "\n" if $cycle %% 40;
}

multi sub insn('addx', Int(Str) $add) {
    cycle();
    cycle();
    $x += $add;
}

multi sub insn('noop') {
    cycle();
}

for $*ARGFILES.IO.lines -> $line {
    insn(|$line.words);
}
