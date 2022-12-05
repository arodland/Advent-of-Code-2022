my $overlap = 0;
for $*ARGFILES.IO.lines -> $line {
    $line ~~ /(\d+) '-' (\d+) ',' (\d+) '-' (\d+)/ or die "huh? $line";
    my ($s1, $e1, $s2, $e2) = $/.list;

    if ($s2 ~~ $s1..$e1 && $e2 ~~ $s1..$e1) || ($s1 ~~ $s2..$e2 && $e1 ~~ $s2..$e2) {
        $overlap++;
    }
}

say $overlap;

