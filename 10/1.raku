my ($x, $cycle, $str) = (1, 0, 0);

sub cycle {
    $cycle++;
    if ($cycle - 20 ) %% 40 {
        say "adding $cycle * $x = { $cycle * $x }";
        $str += $cycle * $x;
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

say $str;
